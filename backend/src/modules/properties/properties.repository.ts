import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

const includeRelations = {
  images: { orderBy: { order: 'asc' as const } },
  units: { where: { deletedAt: null }, orderBy: { reference: 'asc' as const } },
};

@Injectable()
export class PropertiesRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(
    where: Prisma.PropertyWhereInput,
    skip: number,
    take: number,
    orderBy: Prisma.PropertyOrderByWithRelationInput,
  ) {
    return this.prisma.property.findMany({ where, skip, take, orderBy, include: includeRelations });
  }

  count(where: Prisma.PropertyWhereInput) {
    return this.prisma.property.count({ where });
  }

  findById(id: string) {
    return this.prisma.property.findUnique({ where: { id }, include: includeRelations });
  }

  countForOrgAndYear(organizationId: string, year: number) {
    return this.prisma.property.count({
      where: { organizationId, reference: { startsWith: `PROP-${year}-` } },
    });
  }

  create(data: Prisma.PropertyCreateInput) {
    return this.prisma.property.create({ data, include: includeRelations });
  }

  update(id: string, data: Prisma.PropertyUpdateInput) {
    return this.prisma.property.update({ where: { id }, data, include: includeRelations });
  }

  softDelete(id: string) {
    return this.prisma.property.update({ where: { id }, data: { deletedAt: new Date() }, include: includeRelations });
  }

  history(propertyId: string) {
    return this.prisma.propertyHistory.findMany({ where: { propertyId }, orderBy: { createdAt: 'desc' } });
  }

  addHistoryEntries(entries: Prisma.PropertyHistoryCreateManyInput[]) {
    if (entries.length === 0) return Promise.resolve();
    return this.prisma.propertyHistory.createMany({ data: entries });
  }

  findAllWithCoordinates(organizationId: string) {
    return this.prisma.property.findMany({
      where: { organizationId, deletedAt: null, latitude: { not: null }, longitude: { not: null } },
      include: includeRelations,
    });
  }
}
