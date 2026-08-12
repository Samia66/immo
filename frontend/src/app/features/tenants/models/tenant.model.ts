import { PaginationQuery } from '../../../core/models';

export interface Tenant {
  id: string;
  organizationId: string;
  userId?: string | null;
  fullName: string;
  phone: string;
  email?: string | null;
  profession?: string | null;
  employer?: string | null;
  monthlyIncome?: number | null;
  createdAt: string;
  updatedAt: string;
}

export interface CreateTenantDto {
  fullName: string;
  phone: string;
  email?: string;
  profession?: string;
  employer?: string;
  monthlyIncome?: number;
}

export type UpdateTenantDto = Partial<CreateTenantDto>;

export interface TenantQuery extends PaginationQuery {
  search?: string;
}
