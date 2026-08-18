import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma, RoleName } from '@prisma/client';
import { WorkersRepository } from './workers.repository';
import { WorkersMapper } from './workers.mapper';
import { CreateWorkerDto, UpdateWorkerDto, QueryWorkerDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthenticatedUser } from '../../common/interfaces';
import { getManagedPropertyIds } from '../../common/utils/manager-scope.util';

const TENANT_VISIBLE_LEASE_STATUSES = ['ACTIF', 'ENVOYE', 'CONSULTE', 'ACCEPTE'] as const;

@Injectable()
export class WorkersService {
  constructor(
    private readonly repo: WorkersRepository,
    private readonly prisma: PrismaService,
  ) {}

  /**
   * GESTIONNAIRE only sees workers on properties they manage, plus "general" workers
   * (propertyId null, visible org-wide). ADMIN_AGENCE/SUPER_ADMIN keep the unscoped view.
   */
  async findAll(user: AuthenticatedUser, query: QueryWorkerDto) {
    const where: Prisma.WorkerWhereInput = { organizationId: user.organizationId, deletedAt: null };
    const andConditions: Prisma.WorkerWhereInput[] = [];

    if (query.search) {
      andConditions.push({
        OR: [
          { fullName: { contains: query.search, mode: 'insensitive' } },
          { trade: { contains: query.search, mode: 'insensitive' } },
          { phone: { contains: query.search, mode: 'insensitive' } },
        ],
      });
    }

    if (query.propertyId) {
      where.propertyId = query.propertyId;
    } else if (user.roleName === RoleName.GESTIONNAIRE) {
      const propertyIds = await getManagedPropertyIds(this.prisma, user.id);
      andConditions.push({ OR: [{ propertyId: { in: propertyIds } }, { propertyId: null }] });
    }

    if (andConditions.length > 0) where.AND = andConditions;

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(WorkersMapper.toResponse), total, query.page, query.limit);
  }

  async findOne(id: string, user: AuthenticatedUser) {
    const worker = await this.getOwnedOrThrow(id, user);
    return WorkersMapper.toResponse(worker);
  }

  /**
   * LOCATAIRE portal: workers rattached to the tenant's own property (resolved via their most
   * recent non-terminal lease), plus "general" workers with no property (propertyId null).
   */
  async myWorkers(userId: string) {
    const tenant = await this.prisma.tenant.findFirst({ where: { userId } });
    if (!tenant) return [];

    const lease = await this.prisma.lease.findFirst({
      where: { tenantId: tenant.id, status: { in: [...TENANT_VISIBLE_LEASE_STATUSES] } },
      orderBy: { createdAt: 'desc' },
      select: { propertyUnit: { select: { propertyId: true } } },
    });

    const workers = await this.prisma.worker.findMany({
      where: {
        organizationId: tenant.organizationId,
        deletedAt: null,
        isActive: true,
        OR: [{ propertyId: null }, ...(lease ? [{ propertyId: lease.propertyUnit.propertyId }] : [])],
      },
      orderBy: { trade: 'asc' },
    });

    return workers.map(WorkersMapper.toResponse);
  }

  async create(user: AuthenticatedUser, dto: CreateWorkerDto) {
    if (dto.propertyId) {
      await this.assertPropertyManageable(user, dto.propertyId);
    }

    const worker = await this.repo.create({
      organization: { connect: { id: user.organizationId } },
      fullName: dto.fullName,
      trade: dto.trade,
      phone: dto.phone,
      email: dto.email,
      notes: dto.notes,
      isActive: dto.isActive ?? true,
      property: dto.propertyId ? { connect: { id: dto.propertyId } } : undefined,
      createdBy: { connect: { id: user.id } },
    });
    return WorkersMapper.toResponse(worker);
  }

  async update(id: string, user: AuthenticatedUser, dto: UpdateWorkerDto) {
    await this.getOwnedOrThrow(id, user);

    if (dto.propertyId) {
      await this.assertPropertyManageable(user, dto.propertyId);
    }

    const worker = await this.repo.update(id, {
      fullName: dto.fullName,
      trade: dto.trade,
      phone: dto.phone,
      email: dto.email,
      notes: dto.notes,
      isActive: dto.isActive,
      property:
        dto.propertyId !== undefined
          ? dto.propertyId
            ? { connect: { id: dto.propertyId } }
            : { disconnect: true }
          : undefined,
    });
    return WorkersMapper.toResponse(worker);
  }

  async remove(id: string, user: AuthenticatedUser) {
    await this.getOwnedOrThrow(id, user);
    const worker = await this.repo.softDelete(id);
    return WorkersMapper.toResponse(worker);
  }

  private async assertPropertyManageable(user: AuthenticatedUser, propertyId: string) {
    const property = await this.prisma.property.findFirst({
      where: { id: propertyId, organizationId: user.organizationId, deletedAt: null },
    });
    if (!property) throw new BadRequestException('Bien invalide pour cette organisation.');

    if (user.roleName === RoleName.GESTIONNAIRE) {
      const propertyIds = await getManagedPropertyIds(this.prisma, user.id);
      if (!propertyIds.includes(propertyId)) {
        throw new ForbiddenException('Vous ne gérez pas ce bien.');
      }
    }
  }

  private async getOwnedOrThrow(id: string, user: AuthenticatedUser) {
    const worker = await this.repo.findById(id);
    if (!worker) throw new NotFoundException('Ouvrier introuvable.');

    if (user.roleName === RoleName.GESTIONNAIRE && worker.propertyId) {
      const propertyIds = await getManagedPropertyIds(this.prisma, user.id);
      if (!propertyIds.includes(worker.propertyId)) throw new NotFoundException('Ouvrier introuvable.');
    }

    return worker;
  }
}
