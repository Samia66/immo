import { Payment } from '@prisma/client';

type PaymentWithLease = Payment & {
  lease?: {
    id: string;
    property?: { id: string; title: string; reference: string } | null;
    tenant?: { id: string; fullName: string } | null;
  } | null;
};

export class PaymentsMapper {
  static toResponse(payment: PaymentWithLease) {
    return {
      id: payment.id,
      organizationId: payment.organizationId,
      leaseId: payment.leaseId,
      lease: payment.lease
        ? { id: payment.lease.id, property: payment.lease.property, tenant: payment.lease.tenant }
        : undefined,
      amountDue: Number(payment.amountDue),
      amountPaid: Number(payment.amountPaid),
      dueDate: payment.dueDate,
      paidAt: payment.paidAt,
      lateFee: payment.lateFee != null ? Number(payment.lateFee) : null,
      method: payment.method,
      transactionRef: payment.transactionRef,
      status: payment.status,
      receiptUrl: payment.receiptUrl,
      createdAt: payment.createdAt,
      updatedAt: payment.updatedAt,
    };
  }
}
