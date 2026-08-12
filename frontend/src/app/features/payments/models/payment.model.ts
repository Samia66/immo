import { PaginationQuery } from '../../../core/models';
import { PaymentMethod, PaymentStatus } from '../../../core/models/enums';

export interface PaymentLeaseSummary {
  id: string;
  propertyTitle?: string;
  tenantName?: string;
}

export interface Payment {
  id: string;
  organizationId: string;
  leaseId: string;
  lease?: PaymentLeaseSummary;
  amountDue: number;
  amountPaid: number;
  dueDate: string;
  paidAt?: string | null;
  lateFee?: number | null;
  method?: PaymentMethod | null;
  transactionRef?: string | null;
  status: PaymentStatus;
  receiptUrl?: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface RecordPaymentDto {
  leaseId: string;
  amountPaid: number;
  method: PaymentMethod;
  transactionRef?: string;
  paidAt: string;
}

export interface PaymentQuery extends PaginationQuery {
  status?: PaymentStatus;
  propertyId?: string;
  fromDate?: string;
  toDate?: string;
}
