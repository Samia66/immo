import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { OwnersRepository } from './owners.repository';
import { OwnersMapper } from './owners.mapper';
import { CreateOwnerDto, UpdateOwnerDto, QueryOwnerDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class OwnersService {
  constructor(
    private readonly repo: OwnersRepository,
    private readonly prisma: PrismaService,
  ) {}

  async findAll(organizationId: string, query: QueryOwnerDto) {
    const where: Prisma.OwnerWhereInput = { organizationId, deletedAt: null };
    if (query.search) {
      where.OR = [
        { fullName: { contains: query.search, mode: 'insensitive' } },
        { phone: { contains: query.search, mode: 'insensitive' } },
        { email: { contains: query.search, mode: 'insensitive' } },
      ];
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

  async findOne(id: string) {
    const owner = await this.repo.findById(id);
    if (!owner) throw new NotFoundException('Propriétaire introuvable.');

    const properties = await this.prisma.property.findMany({ where: { ownerId: id, deletedAt: null } });
    const propertyIds = properties.map((p) => p.id);

    const revenueAgg =
      propertyIds.length > 0
        ? await this.prisma.payment.aggregate({
            where: { lease: { propertyId: { in: propertyIds } }, status: 'PAYE' },
            _sum: { amountPaid: true },
          })
        : { _sum: { amountPaid: null } };

    return {
      ...OwnersMapper.toResponse(owner, {
        propertiesCount: properties.length,
        totalRevenue: Number(revenueAgg._sum.amountPaid ?? 0),
      }),
      properties: properties.map((p) => ({ id: p.id, reference: p.reference, title: p.title, status: p.status })),
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
