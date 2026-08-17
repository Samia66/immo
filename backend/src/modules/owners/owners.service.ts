import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma, RoleName } from '@prisma/client';
import { OwnersRepository } from './owners.repository';
import { OwnersMapper } from './owners.mapper';
import { CreateOwnerDto, UpdateOwnerDto, QueryOwnerDto, LinkOwnerUserDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthenticatedUser } from '../../common/interfaces';
import { getManagedOwnerIds } from '../../common/utils/manager-scope.util';

@Injectable()
export class OwnersService {
  constructor(
    private readonly repo: OwnersRepository,
    private readonly prisma: PrismaService,
  ) {}

  /**
   * V2 pivot (spec §0/§6): a GESTIONNAIRE only sees the owners explicitly linked to them via an
   * ACTIVE ManagerOwner row. ADMIN_AGENCE/SUPER_ADMIN keep the unscoped org-wide view (dormant
   * back-office "filet de secours" path, left untouched).
   */
  async findAll(user: AuthenticatedUser, query: QueryOwnerDto) {
    const where: Prisma.OwnerWhereInput = { organizationId: user.organizationId, deletedAt: null };
    if (query.search) {
      where.OR = [
        { fullName: { contains: query.search, mode: 'insensitive' } },
        { phone: { contains: query.search, mode: 'insensitive' } },
        { email: { contains: query.search, mode: 'insensitive' } },
      ];
    }

    if (user.roleName === RoleName.GESTIONNAIRE) {
      const ownerIds = await getManagedOwnerIds(this.prisma, user.id);
      where.id = { in: ownerIds };
    }

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(
      items.map((o) => OwnersMapper.toResponse(o)),
      total,
      query.page,
      query.limit,
    );
  }

  async findOne(id: string, user: AuthenticatedUser) {
    const owner = await this.repo.findById(id);
    if (!owner) throw new NotFoundException('Propriétaire introuvable.');

    if (user.roleName === RoleName.GESTIONNAIRE) {
      const link = await this.prisma.managerOwner.findFirst({
        where: { managerId: user.id, ownerId: id, status: 'ACTIVE' },
      });
      if (!link) throw new NotFoundException('Propriétaire introuvable.');
    }

    const properties = await this.prisma.property.findMany({
      where: { ownerId: id, deletedAt: null },
      include: { units: { where: { deletedAt: null }, select: { id: true, status: true } } },
    });
    const propertyIds = properties.map((p) => p.id);

    const revenueAgg =
      propertyIds.length > 0
        ? await this.prisma.payment.aggregate({
            where: { lease: { propertyUnit: { propertyId: { in: propertyIds } } }, status: 'PAYE' },
            _sum: { amountPaid: true },
          })
        : { _sum: { amountPaid: null } };

    return {
      ...OwnersMapper.toResponse(owner, {
        propertiesCount: properties.length,
        totalRevenue: Number(revenueAgg._sum.amountPaid ?? 0),
      }),
      properties: properties.map((p) => ({
        id: p.id,
        reference: p.reference,
        title: p.title,
        unitsCount: p.units.length,
      })),
    };
  }

  async create(organizationId: string, dto: CreateOwnerDto) {
    const owner = await this.repo.create({ organization: { connect: { id: organizationId } }, ...dto });
    return OwnersMapper.toResponse(owner);
  }

  async update(id: string, dto: UpdateOwnerDto) {
    await this.ensureExists(id);
    const owner = await this.repo.update(id, dto);
    return OwnersMapper.toResponse(owner);
  }

  /**
   * Links an Owner record to a portal-login User account (PROPRIETAIRE role), enabling that user
   * to see their own properties/dashboard via the `userId`-scoped `me` endpoints. Mirrors
   * TenantsService.linkUser exactly.
   */
  async linkUser(id: string, dto: LinkOwnerUserDto) {
    const owner = await this.ensureExists(id);

    if (owner.userId && owner.userId !== dto.userId) {
      throw new ConflictException(
        'Ce propriétaire est déjà lié à un autre compte utilisateur. Contactez le support pour modifier ce lien.',
      );
    }

    const user = await this.prisma.user.findFirst({
      where: { id: dto.userId, organizationId: owner.organizationId, deletedAt: null },
      include: { role: true },
    });
    if (!user) throw new BadRequestException('Utilisateur introuvable pour cette organisation.');
    if (user.role.name !== 'PROPRIETAIRE') {
      throw new BadRequestException(
        'Le compte utilisateur doit avoir le rôle PROPRIETAIRE pour être lié à un propriétaire.',
      );
    }

    const alreadyLinked = await this.prisma.owner.findFirst({ where: { userId: dto.userId, id: { not: id } } });
    if (alreadyLinked) {
      throw new ConflictException('Ce compte utilisateur est déjà lié à un autre propriétaire.');
    }

    const ownerUpdated = await this.repo.update(id, { user: { connect: { id: dto.userId } } });
    return OwnersMapper.toResponse(ownerUpdated);
  }

  async remove(id: string) {
    await this.ensureExists(id);
    const activeProperty = await this.prisma.property.findFirst({ where: { ownerId: id, deletedAt: null } });
    if (activeProperty) throw new ConflictException('Impossible de supprimer un propriétaire ayant des biens actifs.');
    const owner = await this.repo.softDelete(id);
    return OwnersMapper.toResponse(owner);
  }

  private async ensureExists(id: string) {
    const owner = await this.repo.findById(id);
    if (!owner) throw new NotFoundException('Propriétaire introuvable.');
    return owner;
  }
}
