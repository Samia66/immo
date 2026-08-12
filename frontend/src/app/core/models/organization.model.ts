import { SubscriptionPlan } from './enums';

export interface Organization {
  id: string;
  name: string;
  code: string;
  address?: string | null;
  phone?: string | null;
  email?: string | null;
  subscriptionPlan: SubscriptionPlan;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface UpdateOrganizationDto {
  name?: string;
  address?: string;
  phone?: string;
  email?: string;
}
