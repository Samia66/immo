import { Expense } from '@prisma/client';

export class ExpensesMapper {
  static toResponse(expense: Expense) {
    return {
      id: expense.id,
      organizationId: expense.organizationId,
      propertyId: expense.propertyId,
      category: expense.category,
      amount: Number(expense.amount),
      description: expense.description,
      expenseDate: expense.expenseDate,
      attachmentUrl: expense.attachmentUrl,
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
    };
  }
}
