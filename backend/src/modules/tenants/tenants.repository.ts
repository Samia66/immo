import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

const includeDocs = { documents: true } as const;

@Injectable()
export class TenantsRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(where: Prisma.TenantWhereInput, skip: number, take: number, orderBy: Prisma.TenantOrderByWithRelationInput) {
    return this.prisma.tenant.findMany({ where, skip, take, orderBy });
  }

  count(where: Prisma.TenantWhereInput) {
    return this.prisma.tenant.count({ where });
  }

  findById(id: string) {
    return this.prisma.tenant.findUnique({ where: { id }, include: includeDocs });
  }

  create(data: Prisma.TenantCreateInput) {
    return this.prisma.tenant.create({ data });
  }

  update(id: string, data: Prisma.TenantUpdateInput) {
    return this.prisma.tenant.update({ where: { id }, data });
  }

  softDelete(id: string) {
    return this.prisma.tenant.update({ where: { id }, data: { deletedAt: new Date() } });
  }

  addDocument(tenantId: string, type: string, url: string) {
    return this.prisma.tenantDocument.create({ data: { tenantId, type, url } });
  }
}
