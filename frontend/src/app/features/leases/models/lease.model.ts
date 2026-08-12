import { PaginationQuery } from '../../../core/models';
import { LeaseStatus, PaymentFrequency } from '../../../core/models/enums';

export interface LeasePropertySummary {
  id: string;
  title: string;
  reference: string;
}

export interface LeaseTenantSummary {
  id: string;
  fullName: string;
}

export interface Lease {
  id: string;
  organizationId: string;
  propertyId: string;
  property?: LeasePropertySummary;
  ownerId: string;
  tenantId: string;
  tenant?: LeaseTenantSummary;
  startDate: string;
  endDate?: string | null;
  rentAmount: number;
  depositAmount: number;
  paymentFrequency: PaymentFrequency;
  indexationRate?: number | null;
  status: LeaseStatus;
  createdAt: string;
  updatedAt: string;
}

export interface CreateLeaseDto {
  propertyId: string;
  tenantId: string;
  startDate: string;
  endDate?: string;
  rentAmount: number;
  depositAmount: number;
  paymentFrequency: PaymentFrequency;
  indexationRate?: number;
}

export interface TerminateLeaseDto {
  terminationDate: string;
  reason?: string;
}

export interface LeaseQuery extends PaginationQuery {
  status?: LeaseStatus;
  propertyId?: string;
  tenantId?: string;
}
