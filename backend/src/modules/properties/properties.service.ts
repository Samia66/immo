import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma, RoleName } from '@prisma/client';
import { PropertiesRepository } from './properties.repository';
import { PropertiesMapper } from './properties.mapper';
import { CreatePropertyDto, UpdatePropertyDto, QueryPropertyDto, NearbyPropertyDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { PropertyUnitsService } from '../property-units/property-units.service';
import { PropertyUnitsMapper } from '../property-units/property-units.mapper';
import { NON_TERMINAL_LEASE_STATUSES } from '../../common/constants/lease-transitions.constant';
import { AuthenticatedUser } from '../../common/interfaces';
import { getManagedPropertyIds } from '../../common/utils/manager-scope.util';

const TRACKED_FIELDS: string[] = ['title', 'type', 'addressLine', 'city', 'district'];

@Injectable()
export class PropertiesService {
  constructor(
    private readonly repo: PropertiesRepository,
    private readonly prisma: PrismaService,
    private readonly units: PropertyUnitsService,
  ) {}

  /**
   * V2 pivot (spec §0/§6): a GESTIONNAIRE only sees properties with an ACTIVE PropertyManagement
   * row for them. ADMIN_AGENCE/SUPER_ADMIN keep the unscoped org-wide view.
   */
  async findAll(user: AuthenticatedUser, query: QueryPropertyDto) {
    const where: Prisma.PropertyWhereInput = { organizationId: user.organizationId, deletedAt: null };
    this.applyFilters(where, query);

    if (user.roleName === RoleName.GESTIONNAIRE) {
      const propertyIds = await getManagedPropertyIds(this.prisma, user.id);
      where.id = { in: propertyIds };
    }

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(await this.mapWithUnits(items), total, query.page, query.limit);
  }

  async findOne(id: string, user: AuthenticatedUser) {
    const property = await this.repo.findById(id);
    if (!property) throw new NotFoundException('Bien introuvable.');

    if (user.roleName === RoleName.GESTIONNAIRE) {
      const link = await this.prisma.propertyManagement.findFirst({
        where: { propertyId: id, managerId: user.id, status: 'ACTIVE' },
      });
      if (!link) throw new NotFoundException('Bien introuvable.');
    }

    if (user.roleName === RoleName.PROPRIETAIRE) {
      const owner = await this.prisma.owner.findFirst({ where: { userId: user.id } });
      if (!owner || property.ownerId !== owner.id) throw new NotFoundException('Bien introuvable.');
    }

    const [mapped] = await this.mapWithUnits([property]);
    return mapped;
  }

  /** PROPRIETAIRE portal: the authenticated user's own properties, with per-unit occupancy info. */
  async myProperties(userId: string, query: QueryPropertyDto) {
    const owner = await this.prisma.owner.findFirst({ where: { userId } });
    if (!owner) return new PaginatedResponseDto([], 0, query.page, query.limit);

    const where: Prisma.PropertyWhereInput = {
      ownerId: owner.id,
      organizationId: owner.organizationId,
      deletedAt: null,
    };
    this.applyFilters(where, query);

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(await this.mapWithUnits(items), total, query.page, query.limit);
  }

  /**
   * Attaches each property's units to its response, with each unit's `currentTenant` batched
   * across every unit on the whole page in a single query (not per-property, not N+1).
   */
  private async mapWithUnits(properties: Awaited<ReturnType<PropertiesRepository['findMany']>>) {
    const allUnitIds = properties.flatMap((p) => p.units.map((u) => u.id));
    const tenantByUnit = await this.units.currentTenantByUnit(allUnitIds);

    return properties.map((p) =>
      PropertiesMapper.toResponse(p, {
        units: p.units.map((u) => PropertyUnitsMapper.toResponse(u, { currentTenant: tenantByUnit.get(u.id) ?? null })),
      }),
    );
  }

  private applyFilters(where: Prisma.PropertyWhereInput, query: QueryPropertyDto) {
    if (query.type) where.type = query.type;
    if (query.city) where.city = { equals: query.city, mode: 'insensitive' };
    if (query.search) {
      where.OR = [
        { title: { contains: query.search, mode: 'insensitive' } },
        { reference: { contains: query.search, mode: 'insensitive' } },
        { addressLine: { contains: query.search, mode: 'insensitive' } },
      ];
    }
    // Nice-to-have: filter properties that have AT LEAST ONE unit matching a status/rent range.
    if (query.unitStatus || query.minRent !== undefined || query.maxRent !== undefined) {
      const unitWhere: Prisma.PropertyUnitWhereInput = { deletedAt: null };
      if (query.unitStatus) unitWhere.status = query.unitStatus;
      if (query.minRent !== undefined || query.maxRent !== undefined) {
        unitWhere.monthlyRent = {};
        if (query.minRent !== undefined) unitWhere.monthlyRent.gte = query.minRent;
        if (query.maxRent !== undefined) unitWhere.monthlyRent.lte = query.maxRent;
      }
      where.units = { some: unitWhere };
    }
  }

  async create(organizationId: string, user: AuthenticatedUser, dto: CreatePropertyDto) {
    const owner = await this.prisma.owner.findFirst({ where: { id: dto.ownerId, organizationId, deletedAt: null } });
    if (!owner) throw new BadRequestException('Propriétaire invalide pour cette organisation.');

    // Security rule (spec §15/§69): the client-supplied ownerId is never trusted as-is — for a
    // GESTIONNAIRE caller it must be backed by an ACTIVE ManagerOwner row before a property can
    // be created for that owner's portfolio.
    if (user.roleName === RoleName.GESTIONNAIRE) {
      const activeLink = await this.prisma.managerOwner.findFirst({
        where: { managerId: user.id, ownerId: dto.ownerId, status: 'ACTIVE' },
      });
      if (!activeLink) {
        throw new ForbiddenException('Vous ne gérez pas ce propriétaire, impossible de créer un bien pour son compte.');
      }
    }

    const reference = await this.generateReference(organizationId);

    const created = await this.prisma.$transaction(async (tx) => {
      const property = await tx.property.create({
        data: {
          organization: { connect: { id: organizationId } },
          reference,
          title: dto.title,
          description: dto.description,
          type: dto.type,
          addressLine: dto.addressLine,
          city: dto.city,
          district: dto.district,
          latitude: dto.latitude,
          longitude: dto.longitude,
          owner: { connect: { id: owner.id } },
        },
      });

      // The new property is immediately visible to its GESTIONNAIRE creator (spec §6).
      if (user.roleName === RoleName.GESTIONNAIRE) {
        await tx.propertyManagement.create({
          data: {
            organization: { connect: { id: organizationId } },
            property: { connect: { id: property.id } },
            manager: { connect: { id: user.id } },
            status: 'ACTIVE',
          },
        });
      }

      return property;
    });

    const full = await this.repo.findById(created.id);
    return PropertiesMapper.toResponse(full!, { units: [] });
  }

  async update(id: string, changedById: string, dto: UpdatePropertyDto) {
    const before = await this.repo.findById(id);
    if (!before) throw new NotFoundException('Bien introuvable.');

    if (dto.ownerId) {
      const owner = await this.prisma.owner.findFirst({
        where: { id: dto.ownerId, organizationId: before.organizationId, deletedAt: null },
      });
      if (!owner) throw new BadRequestException('Propriétaire invalide pour cette organisation.');
    }

    const { ownerId, ...rest } = dto;
    const data: Prisma.PropertyUpdateInput = {
      ...rest,
      owner: ownerId ? { connect: { id: ownerId } } : undefined,
    };

    const after = await this.repo.update(id, data);

    const historyEntries: Prisma.PropertyHistoryCreateManyInput[] = [];
    for (const field of TRACKED_FIELDS) {
      const oldValue = (before as any)[field];
      const newValue = (after as any)[field];
      if (oldValue?.toString() !== newValue?.toString() && newValue !== undefined) {
        historyEntries.push({
          propertyId: id,
          changedById,
          field: field as string,
          oldValue: oldValue?.toString() ?? null,
          newValue: newValue?.toString() ?? null,
        });
      }
    }
    await this.repo.addHistoryEntries(historyEntries);

    const [mapped] = await this.mapWithUnits([after]);
    return mapped;
  }

  async remove(id: string) {
    const property = await this.repo.findById(id);
    if (!property) throw new NotFoundException('Bien introuvable.');

    const blockingLease = await this.prisma.lease.findFirst({
      where: { propertyUnit: { propertyId: id }, status: { in: NON_TERMINAL_LEASE_STATUSES }, deletedAt: null },
    });
    if (blockingLease) throw new ConflictException('Impossible de supprimer un bien avec un contrat en cours.');

    const removed = await this.repo.softDelete(id);
    const [mapped] = await this.mapWithUnits([removed]);
    return mapped;
  }

  async history(id: string, user: AuthenticatedUser) {
    await this.findOne(id, user);
    return this.repo.history(id);
  }

  async nearby(organizationId: string, query: NearbyPropertyDto) {
    const radiusKm = query.radius ?? 5;
    const properties = await this.repo.findAllWithCoordinates(organizationId);

    const withinRadius = properties
      .map((p) => ({
        property: p,
        distanceKm: this.haversine(query.lat, query.lng, p.latitude as number, p.longitude as number),
      }))
      .filter((entry) => entry.distanceKm <= radiusKm)
      .sort((a, b) => a.distanceKm - b.distanceKm);

    const mapped = await this.mapWithUnits(withinRadius.map((entry) => entry.property));

    return mapped.map((property, index) => ({
      ...property,
      distanceKm: Math.round(withinRadius[index].distanceKm * 100) / 100,
    }));
  }

  private async generateReference(organizationId: string): Promise<string> {
    const year = new Date().getFullYear();
    for (let attempt = 0; attempt < 5; attempt++) {
      const count = await this.repo.countForOrgAndYear(organizationId, year);
      const seq = `${count + 1 + attempt}`.padStart(4, '0');
      const candidate = `PROP-${year}-${seq}`;
      const existing = await this.prisma.property.findFirst({ where: { organizationId, reference: candidate } });
      if (!existing) return candidate;
    }
    return `PROP-${year}-${Date.now()}`;
  }

  /** Haversine distance in kilometers — MVP-simple in-memory geo filter (see spec §14.2 note on PostGIS for V2). */
  private haversine(lat1: number, lon1: number, lat2: number, lon2: number): number {
    const toRad = (deg: number) => (deg * Math.PI) / 180;
    const R = 6371;
    const dLat = toRad(lat2 - lat1);
    const dLon = toRad(lon2 - lon1);
    const a = Math.sin(dLat / 2) ** 2 + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) ** 2;
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }
}
