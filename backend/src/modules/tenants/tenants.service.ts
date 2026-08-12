import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { TenantsRepository } from './tenants.repository';
import { TenantsMapper } from './tenants.mapper';
import { CreateTenantDto, UpdateTenantDto, QueryTenantDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { publicUrlFor } from '../../common/utils/file-storage.util';

@Injectable()
export class TenantsService {
  constructor(
    private readonly repo: TenantsRepository,
    private readonly prisma: PrismaService,
  ) {}

  async findAll(organizationId: string, query: QueryTenantDto) {
    const where: Prisma.TenantWhereInput = { organizationId, deletedAt: null };
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
      items.map((t) => TenantsMapper.toResponse(t)),
      total,
      query.page,
      query.limit,
    );
  }

  async findOne(id: string) {
    const tenant = await this.repo.findById(id);
    if (!tenant) throw new NotFoundException('Locataire introuvable.');

    const leases = await this.prisma.lease.findMany({
      where: { tenantId: id },
      include: { property: { select: { id: true, title: true, reference: true } } },
      orderBy: { startDate: 'desc' },
    });

    return {
      ...TenantsMapper.toResponse(tenant),
      leaseHistory: leases.map((l) => ({
        id: l.id,
        property: l.property,
        startDate: l.startDate,
        endDate: l.endDate,
        status: l.status,
        rentAmount: Number(l.rentAmount),
      })),
    };
  }

  async create(organizationId: string, dto: CreateTenantDto) {
    const tenant = await this.repo.create({ organization: { connect: { id: organizationId } }, ...dto });
    return TenantsMapper.toResponse(tenant);
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
