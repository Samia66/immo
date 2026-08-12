import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

const includeRelations = {
  attachments: true,
  property: { select: { id: true, title: true, reference: true } },
  tenant: { select: { id: true, fullName: true, userId: true } },
  assignedTo: { select: { id: true, firstName: true, lastName: true } },
} as const;

@Injectable()
export class MaintenanceRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(
    where: Prisma.MaintenanceRequestWhereInput,
    skip: number,
    take: number,
    orderBy: Prisma.MaintenanceRequestOrderByWithRelationInput,
  ) {
    return this.prisma.maintenanceRequest.findMany({ where, skip, take, orderBy, include: includeRelations });
  }

  count(where: Prisma.MaintenanceRequestWhereInput) {
    return this.prisma.maintenanceRequest.count({ where });
  }

  findById(id: string) {
    return this.prisma.maintenanceRequest.findUnique({ where: { id }, include: includeRelations });
  }

  create(data: Prisma.MaintenanceRequestCreateInput) {
    return this.prisma.maintenanceRequest.create({ data, include: includeRelations });
  }

  update(id: string, data: Prisma.MaintenanceRequestUpdateInput) {
    return this.prisma.maintenanceRequest.update({ where: { id }, data, include: includeRelations });
  }
}
