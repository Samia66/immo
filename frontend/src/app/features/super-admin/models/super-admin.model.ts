import { PaginationQuery } from '../../../core/models';
import { SubscriptionPlan } from '../../../core/models/enums';

export interface OrganizationQuery extends PaginationQuery {
  search?: string;
  isActive?: boolean;
}

export interface CreateOrganizationDto {
  name: string;
  code: string;
  email?: string;
  phone?: string;
  address?: string;
}

export interface SuperAdminStatistics {
  totalOrganizations: number;
  activeOrganizations: number;
  totalUsers: number;
  totalProperties: number;
  organizationsByPlan: { plan: SubscriptionPlan; count: number }[];
}
