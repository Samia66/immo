import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PropertyUnitsRepository } from './property-units.repository';
import { PropertyUnitsMapper, UnitCurrentTenant } from './property-units.mapper';
import { CreatePropertyUnitDto, UpdatePropertyUnitDto, QueryPropertyUnitDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { NON_TERMINAL_LEASE_STATUSES } from '../../common/constants/lease-transitions.constant';

@Injectable()
export class PropertyUnitsService {
  constructor(
    private readonly repo: PropertyUnitsRepository,
    private readonly prisma: PrismaService,
  ) {}

  async findAllForProperty(propertyId: string, organizationId: string, query: QueryPropertyUnitDto) {
    await this.ensurePropertyExists(propertyId, organizationId);

    const where: Prisma.PropertyUnitWhereInput = { propertyId, organizationId, deletedAt: null };
    this.applyFilters(where, query);

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'reference']: query.sortOrder ?? 'asc',
      }),
      this.repo.count(where),
    ]);

    const tenantByUnit = await this.currentTenantByUnit(items.map((u) => u.id));

    return new PaginatedResponseDto(
      items.map((u) => PropertyUnitsMapper.toResponse(u, { currentTenant: tenantByUnit.get(u.id) ?? null })),
      total,
      query.page,
      query.limit,
    );
  }

  async findOne(id: string) {
    const unit = await this.ensureExists(id);
    const tenantByUnit = await this.currentTenantByUnit([unit.id]);
    return PropertyUnitsMapper.toResponse(unit, { currentTenant: tenantByUnit.get(unit.id) ?? null });
  }

  async create(propertyId: string, organizationId: string, dto: CreatePropertyUnitDto) {
    await this.ensurePropertyExists(propertyId, organizationId);

    const existing = await this.repo.findByPropertyAndReference(propertyId, dto.reference);
    if (existing) throw new ConflictException('Cette référence de lot existe déjà pour ce bien.');

    const unit = await this.repo.create({
      organization: { connect: { id: organizationId } },
      property: { connect: { id: propertyId } },
      reference: dto.reference,
      label: dto.label,
      floor: dto.floor,
      type: dto.type,
      rooms: dto.rooms,
      surfaceM2: dto.surfaceM2,
      monthlyRent: dto.monthlyRent,
      monthlyCharges: dto.monthlyCharges,
      description: dto.description,
    });

    return PropertyUnitsMapper.toResponse(unit);
  }

  async update(id: string, dto: UpdatePropertyUnitDto) {
    const before = await this.ensureExists(id);

    if (dto.reference && dto.reference !== before.reference) {
      const existing = await this.repo.findByPropertyAndReference(before.propertyId, dto.reference);
      if (existing) throw new ConflictException('Cette référence de lot existe déjà pour ce bien.');
    }

    const unit = await this.repo.update(id, dto);
    return PropertyUnitsMapper.toResponse(unit);
  }

  async remove(id: string) {
    await this.ensureExists(id);

    const blockingLease = await this.prisma.lease.findFirst({
      where: { propertyUnitId: id, status: { in: NON_TERMINAL_LEASE_STATUSES }, deletedAt: null },
    });
    if (blockingLease) {
      throw new ConflictException('Impossible de supprimer un lot ayant un contrat en cours.');
    }

    const removed = await this.repo.softDelete(id);
    return PropertyUnitsMapper.toResponse(removed);
  }

  /** Batch-fetches the currently-ACTIF lease's tenant for a set of units (avoids N+1). */
  async currentTenantByUnit(unitIds: string[]): Promise<Map<string, UnitCurrentTenant>> {
    if (unitIds.length === 0) return new Map();

    const activeLeases = await this.prisma.lease.findMany({
      where: { propertyUnitId: { in: unitIds }, status: 'ACTIF' },
      include: { tenant: { select: { id: true, fullName: true, phone: true } } },
    });

    return new Map(activeLeases.map((l) => [l.propertyUnitId, l.tenant]));
  }

  private applyFilters(where: Prisma.PropertyUnitWhereInput, query: QueryPropertyUnitDto) {
    if (query.type) where.type = query.type;
    if (query.status) where.status = query.status;
    if (query.minRent !== undefined || query.maxRent !== undefined) {
      where.monthlyRent = {};
      if (query.minRent !== undefined) where.monthlyRent.gte = query.minRent;
      if (query.maxRent !== undefined) where.monthlyRent.lte = query.maxRent;
    }
    if (query.search) {
      where.OR = [
        { reference: { contains: query.search, mode: 'insensitive' } },
        { label: { contains: query.search, mode: 'insensitive' } },
      ];
    }
  }

  private async ensurePropertyExists(propertyId: string, organizationId: string) {
    const property = await this.prisma.property.findFirst({
      where: { id: propertyId, organizationId, deletedAt: null },
    });
    if (!property) throw new BadRequestException('Bien invalide pour cette organisation.');
    return property;
  }

  private async ensureExists(id: string) {
    const unit = await this.repo.findById(id);
    if (!unit || unit.deletedAt) throw new NotFoundException('Lot introuvable.');
    return unit;
  }
}
