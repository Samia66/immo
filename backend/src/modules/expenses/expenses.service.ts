import { Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { ExpensesRepository } from './expenses.repository';
import { ExpensesMapper } from './expenses.mapper';
import { CreateExpenseDto, UpdateExpenseDto, QueryExpenseDto, ExpenseReportQueryDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { monthKey } from '../../common/utils/date-helpers.util';

@Injectable()
export class ExpensesService {
  constructor(
    private readonly repo: ExpensesRepository,
    private readonly prisma: PrismaService,
  ) {}

  async findAll(organizationId: string, query: QueryExpenseDto) {
    const where: Prisma.ExpenseWhereInput = { organizationId, deletedAt: null };
    if (query.propertyId) where.propertyId = query.propertyId;
    if (query.category) where.category = query.category;
    if (query.fromDate || query.toDate) {
      where.expenseDate = {};
      if (query.fromDate) where.expenseDate.gte = new Date(query.fromDate);
      if (query.toDate) where.expenseDate.lte = new Date(query.toDate);
    }

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'expenseDate']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(ExpensesMapper.toResponse), total, query.page, query.limit);
  }

  async create(organizationId: string, dto: CreateExpenseDto) {
    const property = await this.prisma.property.findFirst({
      where: { id: dto.propertyId, organizationId, deletedAt: null },
    });
    if (!property) throw new NotFoundException('Bien introuvable pour cette organisation.');

    const expense = await this.repo.create({
      organization: { connect: { id: organizationId } },
      property: { connect: { id: dto.propertyId } },
      category: dto.category,
      amount: dto.amount,
      description: dto.description,
      expenseDate: new Date(dto.expenseDate),
    });
    return ExpensesMapper.toResponse(expense);
  }

  async update(id: string, dto: UpdateExpenseDto) {
    await this.ensureExists(id);
    const { propertyId, ...rest } = dto;
    const data: Prisma.ExpenseUpdateInput = {
      ...rest,
      expenseDate: dto.expenseDate ? new Date(dto.expenseDate) : undefined,
      property: propertyId ? { connect: { id: propertyId } } : undefined,
    };
    const expense = await this.repo.update(id, data);
    return ExpensesMapper.toResponse(expense);
  }

  async remove(id: string) {
    await this.ensureExists(id);
    const expense = await this.repo.softDelete(id);
    return ExpensesMapper.toResponse(expense);
  }

  async report(organizationId: string, query: ExpenseReportQueryDto) {
    const fromDate = query.fromDate ? new Date(query.fromDate) : undefined;
    const toDate = query.toDate ? new Date(query.toDate) : undefined;
    const expenses = await this.repo.findAllForReport(organizationId, fromDate, toDate);

    const groups = new Map<string, { key: string; label: string; total: number; count: number }>();

    for (const expense of expenses) {
      let key: string;
      let label: string;
      if (query.groupBy === 'property') {
        key = expense.propertyId;
        label = expense.property.title;
      } else if (query.groupBy === 'category') {
        key = expense.category;
        label = expense.category;
      } else {
        key = monthKey(expense.expenseDate);
        label = key;
      }

      const existing = groups.get(key) ?? { key, label, total: 0, count: 0 };
      existing.total += Number(expense.amount);
      existing.count += 1;
      groups.set(key, existing);
    }

    return {
      groupBy: query.groupBy,
      totalAmount: expenses.reduce((sum, e) => sum + Number(e.amount), 0),
      groups: Array.from(groups.values()).sort((a, b) => b.total - a.total),
    };
  }

  private async ensureExists(id: string) {
    const expense = await this.repo.findById(id);
    if (!expense) throw new NotFoundException('Charge introuvable.');
    return expense;
  }
}
