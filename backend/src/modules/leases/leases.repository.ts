import { Injectable } from '@nestjs/common';
import { LeaseStatus, Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

const includeRelations = {
  documents: true,
  amendments: { orderBy: { createdAt: 'desc' as const } },
  propertyUnit: {
    select: {
      id: true,
      reference: true,
      label: true,
      status: true,
      property: { select: { id: true, title: true, reference: true, addressLine: true, city: true } },
    },
  },
  tenant: { select: { id: true, fullName: true, userId: true } },
};

@Injectable()
export class LeasesRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(where: Prisma.LeaseWhereInput, skip: number, take: number, orderBy: Prisma.LeaseOrderByWithRelationInput) {
    return this.prisma.lease.findMany({ where, skip, take, orderBy, include: includeRelations });
  }

  count(where: Prisma.LeaseWhereInput) {
    return this.prisma.lease.count({ where });
  }

  findById(id: string) {
    return this.prisma.lease.findUnique({ where: { id }, include: includeRelations });
  }

  create(data: Prisma.LeaseCreateInput) {
    return this.prisma.lease.create({ data, include: includeRelations });
  }

  update(id: string, data: Prisma.LeaseUpdateInput) {
    return this.prisma.lease.update({ where: { id }, data, include: includeRelations });
  }

  expiringSoon(organizationId: string, from: Date, to: Date) {
    return this.prisma.lease.findMany({
      where: { organizationId, status: 'ACTIF', endDate: { gte: from, lte: to } },
      include: includeRelations,
      orderBy: { endDate: 'asc' },
    });
  }

  addDocument(leaseId: string, type: string, url: string) {
    return this.prisma.leaseDocument.create({ data: { leaseId, type, url } });
  }

  addAmendment(leaseId: string, description: string, effectiveDate: Date) {
    return this.prisma.leaseAmendment.create({ data: { leaseId, description, effectiveDate } });
  }

  addHistory(
    leaseId: string,
    fromStatus: LeaseStatus | null,
    toStatus: LeaseStatus,
    changedById?: string,
    note?: string,
  ) {
    return this.prisma.leaseStatusHistory.create({
      data: { leaseId, fromStatus: fromStatus ?? undefined, toStatus, changedById, note },
    });
  }
}
