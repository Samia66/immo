import { PaginationQuery } from '../../../core/models';
import { MaintenancePriority, MaintenanceStatus } from '../../../core/models/enums';

export interface MaintenancePropertySummary {
  id: string;
  title: string;
}

export interface MaintenanceRequest {
  id: string;
  organizationId: string;
  propertyId: string;
  property?: MaintenancePropertySummary;
  tenantId?: string | null;
  category: string;
  description: string;
  priority: MaintenancePriority;
  status: MaintenanceStatus;
  assignedToId?: string | null;
  estimatedCost?: number | null;
  actualCost?: number | null;
  scheduledAt?: string | null;
  startedAt?: string | null;
  completedAt?: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface CreateMaintenanceRequestDto {
  propertyId: string;
  tenantId?: string;
  category: string;
  description: string;
  priority?: MaintenancePriority;
}

export interface AssignMaintenanceDto {
  assignedToId: string;
  scheduledAt?: string;
  estimatedCost?: number;
}

export interface UpdateMaintenanceStatusDto {
  status: MaintenanceStatus;
  actualCost?: number;
}

export interface MaintenanceQuery extends PaginationQuery {
  status?: MaintenanceStatus;
  priority?: MaintenancePriority;
  propertyId?: string;
}
