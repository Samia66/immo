import { PaginationQuery } from '../../../core/models';
import { LeaseStatus, PaymentFrequency } from '../../../core/models/enums';

export interface LeasePropertySummary {
  id: string;
  title: string;
  reference: string;
  addressLine: string;
  city: string;
}

/** Matches the backend's `Lease.propertyUnit` shape (LeasesMapper) — the unit plus its parent building. */
export interface LeasePropertyUnitSummary {
  id: string;
  reference: string;
  label: string | null;
  status: string;
  property: LeasePropertySummary;
}

export interface LeaseTenantSummary {
  id: string;
  fullName: string;
}

export interface Lease {
  id: string;
  organizationId: string;
  reference: string;
  propertyUnitId: string;
  propertyUnit?: LeasePropertyUnitSummary | null;
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
  propertyUnitId: string;
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

export interface RefuseLeaseDto {
  reason?: string;
}

/** Response of `POST /leases/:id/invite` — an activation invitation for the lease's tenant. */
export interface InvitationResult {
  id: string;
  code: string;
  status: string;
  expiresAt: string;
  shareMessage: string;
}

export interface LeaseQuery extends PaginationQuery {
  status?: LeaseStatus;
  propertyUnitId?: string;
  tenantId?: string;
}
