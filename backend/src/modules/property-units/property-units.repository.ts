import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class PropertyUnitsRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(
    where: Prisma.PropertyUnitWhereInput,
    skip: number,
    take: number,
    orderBy: Prisma.PropertyUnitOrderByWithRelationInput,
  ) {
    return this.prisma.propertyUnit.findMany({ where, skip, take, orderBy });
  }

  count(where: Prisma.PropertyUnitWhereInput) {
    return this.prisma.propertyUnit.count({ where });
  }

  findById(id: string) {
    return this.prisma.propertyUnit.findUnique({ where: { id } });
  }

  findByPropertyAndReference(propertyId: string, reference: string) {
    return this.prisma.propertyUnit.findFirst({ where: { propertyId, reference } });
  }

  create(data: Prisma.PropertyUnitCreateInput) {
    return this.prisma.propertyUnit.create({ data });
  }

  update(id: string, data: Prisma.PropertyUnitUpdateInput) {
    return this.prisma.propertyUnit.update({ where: { id }, data });
  }

  softDelete(id: string) {
    return this.prisma.propertyUnit.update({ where: { id }, data: { deletedAt: new Date() } });
  }
}
