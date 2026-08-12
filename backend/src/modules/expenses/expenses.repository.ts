import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class ExpensesRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(
    where: Prisma.ExpenseWhereInput,
    skip: number,
    take: number,
    orderBy: Prisma.ExpenseOrderByWithRelationInput,
  ) {
    return this.prisma.expense.findMany({ where, skip, take, orderBy });
  }

  count(where: Prisma.ExpenseWhereInput) {
    return this.prisma.expense.count({ where });
  }

  findById(id: string) {
    return this.prisma.expense.findUnique({ where: { id } });
  }

  create(data: Prisma.ExpenseCreateInput) {
    return this.prisma.expense.create({ data });
  }

  update(id: string, data: Prisma.ExpenseUpdateInput) {
    return this.prisma.expense.update({ where: { id }, data });
  }

  softDelete(id: string) {
    return this.prisma.expense.update({ where: { id }, data: { deletedAt: new Date() } });
  }

  findAllForReport(organizationId: string, fromDate?: Date, toDate?: Date) {
    const where: Prisma.ExpenseWhereInput = { organizationId, deletedAt: null };
    if (fromDate || toDate) {
      where.expenseDate = {};
      if (fromDate) where.expenseDate.gte = fromDate;
      if (toDate) where.expenseDate.lte = toDate;
    }
    return this.prisma.expense.findMany({
      where,
      include: { property: { select: { id: true, title: true, reference: true } } },
    });
  }
}
