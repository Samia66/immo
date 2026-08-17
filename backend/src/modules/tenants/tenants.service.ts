import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma, RoleName } from '@prisma/client';
import { TenantsRepository } from './tenants.repository';
import { TenantsMapper } from './tenants.mapper';
import { CreateTenantDto, UpdateTenantDto, QueryTenantDto, LinkTenantUserDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { publicUrlFor } from '../../common/utils/file-storage.util';
import { AuthenticatedUser } from '../../common/interfaces';

@Injectable()
export class TenantsService {
  constructor(
    private readonly repo: TenantsRepository,
    private readonly prisma: PrismaService,
  ) {}

  /**
   * V2 pivot (spec §0/§6): a GESTIONNAIRE sees tenants they created (createdByManagerId) OR that
   * have at least one Lease they manage (denormalized Lease.managerId) — the "created" branch is
   * required because a freshly-created tenant has no Lease yet, and would otherwise be invisible
   * to the very manager who just created it. ADMIN_AGENCE/SUPER_ADMIN keep the unscoped org-wide view.
   */
  async findAll(user: AuthenticatedUser, query: QueryTenantDto) {
    const where: Prisma.TenantWhereInput = { organizationId: user.organizationId, deletedAt: null };
    const andConditions: Prisma.TenantWhereInput[] = [];

    if (query.search) {
      andConditions.push({
        OR: [
          { fullName: { contains: query.search, mode: 'insensitive' } },
          { phone: { contains: query.search, mode: 'insensitive' } },
          { email: { contains: query.search, mode: 'insensitive' } },
        ],
      });
    }

    if (user.roleName === RoleName.GESTIONNAIRE) {
      andConditions.push({
        OR: [{ createdByManagerId: user.id }, { leases: { some: { managerId: user.id } } }],
      });
    }

    if (andConditions.length > 0) {
      where.AND = andConditions;
    }

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(
      items.map((t) => TenantsMapper.toResponse(t)),
      total,
      query.page,
      query.limit,
    );
  }

  async findOne(id: string, user: AuthenticatedUser) {
    const tenant = await this.repo.findById(id);
    if (!tenant) throw new NotFoundException('Locataire introuvable.');

    if (user.roleName === RoleName.GESTIONNAIRE && tenant.createdByManagerId !== user.id) {
      const managed = await this.prisma.lease.findFirst({ where: { tenantId: id, managerId: user.id } });
      if (!managed) throw new NotFoundException('Locataire introuvable.');
    }

    const leases = await this.prisma.lease.findMany({
      where: { tenantId: id },
      include: {
        propertyUnit: {
          select: { id: true, reference: true, label: true, property: { select: { id: true, title: true } } },
        },
      },
      orderBy: { startDate: 'desc' },
    });

    return {
      ...TenantsMapper.toResponse(tenant),
      leaseHistory: leases.map((l) => ({
        id: l.id,
        propertyUnit: l.propertyUnit,
        startDate: l.startDate,
        endDate: l.endDate,
        status: l.status,
        rentAmount: Number(l.rentAmount),
      })),
    };
  }

  /**
   * Spec §9/§14: before creating a fresh Tenant, look for a User already in this organization
   * with a matching email/phone. If one exists and already carries the LOCATAIRE role, the new
   * Tenant is linked to it immediately (the "existing account" path, §14) — no separate
   * link-user/invitation step needed. Otherwise the tenant is created unlinked, the "new
   * account, needs invitation" path (§12/§13): a manager later calls POST /leases/:id/invite.
   */
  async create(user: AuthenticatedUser, dto: CreateTenantDto) {
    const matchedUserId = await this.findLinkableExistingUser(user.organizationId, dto.email, dto.phone);

    const tenant = await this.repo.create({
      organization: { connect: { id: user.organizationId } },
      ...dto,
      user: matchedUserId ? { connect: { id: matchedUserId } } : undefined,
      createdByManager: user.roleName === RoleName.GESTIONNAIRE ? { connect: { id: user.id } } : undefined,
    });
    return TenantsMapper.toResponse(tenant);
  }

  private async findLinkableExistingUser(
    organizationId: string,
    email?: string,
    phone?: string,
  ): Promise<string | undefined> {
    const orConditions: Prisma.UserWhereInput[] = [];
    if (email) orConditions.push({ email: { equals: email, mode: 'insensitive' } });
    if (phone) orConditions.push({ phone });
    if (orConditions.length === 0) return undefined;

    const existingUser = await this.prisma.user.findFirst({
      where: { organizationId, deletedAt: null, OR: orConditions },
      include: { role: true },
    });
    if (!existingUser || existingUser.role.name !== 'LOCATAIRE') return undefined;

    // Tenant.userId is unique — never auto-link a User account that's already someone else's profile.
    const alreadyLinked = await this.prisma.tenant.findFirst({ where: { userId: existingUser.id } });
    if (alreadyLinked) return undefined;

    return existingUser.id;
  }

  async update(id: string, dto: UpdateTenantDto) {
    await this.ensureExists(id);
    const tenant = await this.repo.update(id, dto);
    return TenantsMapper.toResponse(tenant);
  }

  async remove(id: string) {
    await this.ensureExists(id);
    const activeLease = await this.prisma.lease.findFirst({
      where: { tenantId: id, status: 'ACTIF', deletedAt: null },
    });
    if (activeLease) throw new ConflictException('Impossible de supprimer un locataire ayant un contrat actif.');
    const tenant = await this.repo.softDelete(id);
    return TenantsMapper.toResponse(tenant);
  }

  /**
   * Links a Tenant record to a portal-login User account (LOCATAIRE role), enabling that user
   * to see their own lease/payments/maintenance via the `userId`-scoped `me` endpoints.
   */
  async linkUser(id: string, dto: LinkTenantUserDto) {
    await this.assertLinkable(id, dto.userId);
    const tenantUpdated = await this.repo.update(id, { user: { connect: { id: dto.userId } } });
    return TenantsMapper.toResponse(tenantUpdated);
  }

  /**
   * Validates that `userId` (role LOCATAIRE, same org) can be linked to tenant `id` — same
   * underlying rules as the admin-triggered `linkUser()` above, factored out so
   * InvitationsService's OTP-verified self-activation flow (`POST /invitations/:code/activate`)
   * can run the identical checks before linking the tenant inside its own transaction, without
   * duplicating the validation. Throws on any violation; does not perform the write itself so
   * the caller may run it inside an existing Prisma transaction.
   */
  async assertLinkable(id: string, userId: string): Promise<void> {
    const tenant = await this.ensureExists(id);

    if (tenant.userId && tenant.userId !== userId) {
      throw new ConflictException(
        'Ce locataire est déjà lié à un autre compte utilisateur. Contactez le support pour modifier ce lien.',
      );
    }

    const user = await this.prisma.user.findFirst({
      where: { id: userId, organizationId: tenant.organizationId, deletedAt: null },
      include: { role: true },
    });
    if (!user) throw new BadRequestException('Utilisateur introuvable pour cette organisation.');
    if (user.role.name !== 'LOCATAIRE') {
      throw new BadRequestException('Le compte utilisateur doit avoir le rôle LOCATAIRE pour être lié à un locataire.');
    }

    const alreadyLinked = await this.prisma.tenant.findFirst({ where: { userId, id: { not: id } } });
    if (alreadyLinked) {
      throw new ConflictException('Ce compte utilisateur est déjà lié à un autre locataire.');
    }
  }

  async addDocument(id: string, type: string, file: Express.Multer.File) {
    await this.ensureExists(id);
    const url = publicUrlFor('tenants', file.filename);
    const doc = await this.repo.addDocument(id, type, url);
    return { id: doc.id, type: doc.type, url: doc.url, createdAt: doc.createdAt };
  }

  private async ensureExists(id: string) {
    const tenant = await this.repo.findById(id);
    if (!tenant) throw new NotFoundException('Locataire introuvable.');
    return tenant;
  }
}
