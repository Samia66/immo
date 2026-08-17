import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

const includeLease = {
  lease: {
    include: {
      propertyUnit: {
        select: { id: true, reference: true, label: true, property: { select: { id: true, title: true } } },
      },
      tenant: { select: { id: true, fullName: true, userId: true } },
    },
  },
} as const;

@Injectable()
export class PaymentsRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(
    where: Prisma.PaymentWhereInput,
    skip: number,
    take: number,
    orderBy: Prisma.PaymentOrderByWithRelationInput,
  ) {
    return this.prisma.payment.findMany({ where, skip, take, orderBy, include: includeLease });
  }

  count(where: Prisma.PaymentWhereInput) {
    return this.prisma.payment.count({ where });
  }

  findById(id: string) {
    return this.prisma.payment.findUnique({ where: { id }, include: includeLease });
  }

  create(data: Prisma.PaymentCreateInput) {
    return this.prisma.payment.create({ data, include: includeLease });
  }

  update(id: string, data: Prisma.PaymentUpdateInput) {
    return this.prisma.payment.update({ where: { id }, data, include: includeLease });
  }
}
