import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

const includePayment = {
  payment: {
    include: {
      lease: {
        include: {
          propertyUnit: {
            select: { id: true, reference: true, label: true, property: { select: { id: true, title: true } } },
          },
          tenant: { select: { id: true, fullName: true, userId: true } },
        },
      },
    },
  },
} as const;

@Injectable()
export class ReceiptsRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(
    where: Prisma.ReceiptWhereInput,
    skip: number,
    take: number,
    orderBy: Prisma.ReceiptOrderByWithRelationInput,
  ) {
    return this.prisma.receipt.findMany({ where, skip, take, orderBy, include: includePayment });
  }

  count(where: Prisma.ReceiptWhereInput) {
    return this.prisma.receipt.count({ where });
  }

  findById(id: string) {
    return this.prisma.receipt.findUnique({ where: { id }, include: includePayment });
  }
}
