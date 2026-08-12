import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma, RoleName } from '@prisma/client';
import { OrganizationsRepository } from './organizations.repository';
import { OrganizationsMapper } from './organizations.mapper';
import { CreateOrganizationDto, UpdateOrganizationDto, UpdateSubscriptionDto, QueryOrganizationDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { ROLE_LABELS, ROLE_PERMISSIONS } from '../../common/constants/permissions.constant';

@Injectable()
export class OrganizationsService {
  constructor(
    private readonly repo: OrganizationsRepository,
    private readonly prisma: PrismaService,
  ) {}

  async findAll(query: QueryOrganizationDto) {
    const where: Prisma.OrganizationWhereInput = { deletedAt: null };
    if (query.search) {
      where.OR = [
        { name: { contains: query.search, mode: 'insensitive' } },
        { code: { contains: query.search, mode: 'insensitive' } },
      ];
    }
    if (query.isActive !== undefined) {
      where.isActive = query.isActive === 'true';
    }

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(OrganizationsMapper.toResponse), total, query.page, query.limit);
  }

  async findOne(id: string) {
    const org = await this.repo.findById(id);
    if (!org) throw new NotFoundException('Organisation introuvable.');
    return OrganizationsMapper.toResponse(org);
  }

  async create(dto: CreateOrganizationDto) {
    const code = dto.code ?? (await this.generateCode(dto.name));
    const existing = await this.repo.findByCode(code);
    if (existing) throw new ConflictException('Ce code d’organisation est déjà utilisé.');

    const org = await this.prisma.$transaction(async (tx) => {
      const organization = await tx.organization.create({
        data: { name: dto.name, code, address: dto.address, phone: dto.phone, email: dto.email },
      });

      const allPermissions = await tx.permission.findMany();
      const permissionsByCode = new Map(allPermissions.map((p) => [p.code, p.id]));
      const roleNames: RoleName[] = ['ADMIN_AGENCE', 'GESTIONNAIRE', 'AGENT_IMMOBILIER', 'LOCATAIRE'];

      for (const roleName of roleNames) {
        const role = await tx.role.create({
          data: { organizationId: organization.id, name: roleName, label: ROLE_LABELS[roleName], isSystem: true },
        });
        const codes = ROLE_PERMISSIONS[roleName as Exclude<RoleName, 'SUPER_ADMIN'>] ?? [];
        const rows = codes
          .map((c) => permissionsByCode.get(c))
          .filter((id): id is string => Boolean(id))
          .map((permissionId) => ({ roleId: role.id, permissionId }));
        if (rows.length) await tx.rolePermission.createMany({ data: rows, skipDuplicates: true });
      }

      return organization;
    });

    return OrganizationsMapper.toResponse(org);
  }

  async update(id: string, dto: UpdateOrganizationDto) {
    await this.ensureExists(id);
    const org = await this.repo.update(id, dto);
    return OrganizationsMapper.toResponse(org);
  }

  async updateMe(organizationId: string, dto: UpdateOrganizationDto) {
    return this.update(organizationId, dto);
  }

  async findMe(organizationId: string) {
    return this.findOne(organizationId);
  }

  async updateSubscription(id: string, dto: UpdateSubscriptionDto) {
    await this.ensureExists(id);
    const org = await this.repo.update(id, { subscriptionPlan: dto.subscriptionPlan });
    return OrganizationsMapper.toResponse(org);
  }

  async toggleActive(id: string) {
    const org = await this.ensureExists(id);
    const updated = await this.repo.update(id, { isActive: !org.isActive });
    return OrganizationsMapper.toResponse(updated);
  }

  private async ensureExists(id: string) {
    const org = await this.repo.findById(id);
    if (!org) throw new NotFoundException('Organisation introuvable.');
    return org;
  }

  private async generateCode(name: string): Promise<string> {
    const base =
      name
        .toUpperCase()
        .normalize('NFD')
        .replace(/[̀-ͯ]/g, '')
        .replace(/[^A-Z0-9]+/g, '-')
        .replace(/(^-|-$)/g, '')
        .slice(0, 20) || 'ORG';
    let candidate = base;
    let attempt = 0;
    while (await this.repo.findByCode(candidate)) {
      attempt += 1;
      candidate = `${base}-${Math.random().toString(36).slice(2, 6).toUpperCase()}`;
      if (attempt > 10) candidate = `${base}-${Date.now()}`;
    }
    return candidate;
  }
}
