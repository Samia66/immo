import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PropertiesRepository } from './properties.repository';
import { PropertiesMapper } from './properties.mapper';
import { CreatePropertyDto, UpdatePropertyDto, QueryPropertyDto, NearbyPropertyDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';

const TRACKED_FIELDS: string[] = ['title', 'type', 'status', 'addressLine', 'city', 'monthlyRent', 'monthlyCharges'];

@Injectable()
export class PropertiesService {
  constructor(
    private readonly repo: PropertiesRepository,
    private readonly prisma: PrismaService,
  ) {}

  async findAll(organizationId: string, query: QueryPropertyDto) {
    const where: Prisma.PropertyWhereInput = { organizationId, deletedAt: null };
    if (query.type) where.type = query.type;
    if (query.status) where.status = query.status;
    if (query.city) where.city = { equals: query.city, mode: 'insensitive' };
    if (query.minRent !== undefined || query.maxRent !== undefined) {
      where.monthlyRent = {};
      if (query.minRent !== undefined) where.monthlyRent.gte = query.minRent;
      if (query.maxRent !== undefined) where.monthlyRent.lte = query.maxRent;
    }
    if (query.search) {
      where.OR = [
        { title: { contains: query.search, mode: 'insensitive' } },
        { reference: { contains: query.search, mode: 'insensitive' } },
        { addressLine: { contains: query.search, mode: 'insensitive' } },
      ];
    }

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(PropertiesMapper.toResponse), total, query.page, query.limit);
  }

  async findOne(id: string) {
    const property = await this.repo.findById(id);
    if (!property) throw new NotFoundException('Bien introuvable.');
    return PropertiesMapper.toResponse(property);
  }

  async create(organizationId: string, dto: CreatePropertyDto) {
    const owner = await this.prisma.owner.findFirst({ where: { id: dto.ownerId, organizationId, deletedAt: null } });
    if (!owner) throw new BadRequestException('Propriétaire invalide pour cette organisation.');

    const reference = await this.generateReference(organizationId);

    const property = await this.repo.create({
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
      rooms: dto.rooms,
      surfaceM2: dto.surfaceM2,
      monthlyRent: dto.monthlyRent,
      monthlyCharges: dto.monthlyCharges,
      owner: { connect: { id: owner.id } },
    });

    return PropertiesMapper.toResponse(property);
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

    return PropertiesMapper.toResponse(after);
  }

  async remove(id: string) {
    const property = await this.repo.findById(id);
    if (!property) throw new NotFoundException('Bien introuvable.');

    const activeLease = await this.prisma.lease.findFirst({
      where: { propertyId: id, status: 'ACTIF', deletedAt: null },
    });
    if (activeLease) throw new ConflictException('Impossible de supprimer un bien avec un contrat actif.');

    const removed = await this.repo.softDelete(id);
    return PropertiesMapper.toResponse(removed);
  }

  async history(id: string) {
    await this.findOne(id);
    return this.repo.history(id);
  }

  async nearby(organizationId: string, query: NearbyPropertyDto) {
    const radiusKm = query.radius ?? 5;
    const properties = await this.repo.findAllWithCoordinates(organizationId);

    return properties
      .map((p) => ({
        property: p,
        distanceKm: this.haversine(query.lat, query.lng, p.latitude as number, p.longitude as number),
      }))
      .filter((entry) => entry.distanceKm <= radiusKm)
      .sort((a, b) => a.distanceKm - b.distanceKm)
      .map((entry) => ({
        ...PropertiesMapper.toResponse(entry.property),
        distanceKm: Math.round(entry.distanceKm * 100) / 100,
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
