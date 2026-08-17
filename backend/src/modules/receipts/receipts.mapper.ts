import { Payment, Receipt } from '@prisma/client';

type ReceiptWithRelations = Receipt & {
  payment?:
    | (Payment & {
        lease?: {
          id: string;
          reference: string;
          propertyUnit: {
            id: string;
            reference: string;
            label: string | null;
            property: { id: string; title: string };
          };
          tenant: { id: string; fullName: string; userId: string | null };
        } | null;
      })
    | null;
};

export class ReceiptsMapper {
  static toResponse(receipt: ReceiptWithRelations) {
    return {
      id: receipt.id,
      organizationId: receipt.organizationId,
      paymentId: receipt.paymentId,
      url: receipt.url,
      period: receipt.period,
      amount: Number(receipt.amount),
      generatedAt: receipt.generatedAt,
      payment: receipt.payment
        ? {
            id: receipt.payment.id,
            status: receipt.payment.status,
            amountPaid: Number(receipt.payment.amountPaid),
            dueDate: receipt.payment.dueDate,
            paidAt: receipt.payment.paidAt,
            lease: receipt.payment.lease
              ? {
                  id: receipt.payment.lease.id,
                  reference: receipt.payment.lease.reference,
                  propertyUnit: receipt.payment.lease.propertyUnit,
                  tenant: receipt.payment.lease.tenant,
                }
              : undefined,
          }
        : undefined,
    };
  }
}
