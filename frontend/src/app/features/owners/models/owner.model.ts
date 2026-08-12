import { PaginationQuery } from '../../../core/models';

export interface Owner {
  id: string;
  organizationId: string;
  fullName: string;
  phone: string;
  email?: string | null;
  address?: string | null;
  idDocumentUrl?: string | null;
  bankName?: string | null;
  bankAccountIban?: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface CreateOwnerDto {
  fullName: string;
  phone: string;
  email?: string;
  address?: string;
  bankName?: string;
  bankAccountIban?: string;
}

export type UpdateOwnerDto = Partial<CreateOwnerDto>;

export interface OwnerQuery extends PaginationQuery {
  search?: string;
}
