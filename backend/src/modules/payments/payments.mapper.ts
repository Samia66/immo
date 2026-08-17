import { Payment } from '@prisma/client';

type PaymentWithLease = Payment & {
  lease?: {
    id: string;
    propertyUnit?: {
      id: string;
      reference: string;
      label: string | null;
      property: { id: string; title: string };
    } | null;
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
        ? { id: payment.lease.id, propertyUnit: payment.lease.propertyUnit, tenant: payment.lease.tenant }
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
