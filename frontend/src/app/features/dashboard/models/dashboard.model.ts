import { MaintenancePriority, MaintenanceStatus, PropertyStatus } from '../../../core/models/enums';

export interface AdminDashboardKpis {
  totalProperties: number;
  occupancyRate: number;
  monthlyRevenue: number;
  overduePaymentsCount: number;
  overduePaymentsAmount: number;
  openMaintenanceCount: number;
  expiringLeasesCount: number;
}

export interface RevenueByMonth {
  month: string;
  amount: number;
}

export interface PropertiesByStatus {
  status: PropertyStatus;
  count: number;
}

export interface ExpiringLeaseSummary {
  leaseId: string;
  propertyTitle: string;
  endDate: string;
}

export interface OpenMaintenanceSummary {
  id: string;
  propertyTitle: string;
  priority: MaintenancePriority;
  status: MaintenanceStatus;
}

/** Exact shape of `GET /dashboard/admin` — see SPECIFICATION.md §11.2. */
export interface AdminDashboard {
  kpis: AdminDashboardKpis;
  revenueByMonth: RevenueByMonth[];
  propertiesByStatus: PropertiesByStatus[];
  expiringLeases: ExpiringLeaseSummary[];
  openMaintenance: OpenMaintenanceSummary[];
}

export interface ManagerDashboardKpis {
  totalProperties: number;
  occupancyRate: number;
  openMaintenanceCount: number;
  expiringLeasesCount: number;
  pendingPaymentsCount: number;
}

export interface ManagerDashboard {
  kpis: ManagerDashboardKpis;
  expiringLeases: ExpiringLeaseSummary[];
  openMaintenance: OpenMaintenanceSummary[];
}

export interface TenantDashboardNextPayment {
  amountDue: number;
  dueDate: string;
  paymentId: string;
}

export interface TenantDashboardLeaseSummary {
  propertyTitle: string;
  startDate: string;
  endDate?: string | null;
  rentAmount: number;
}

export interface TenantDashboardPaymentSummary {
  id: string;
  amountDue: number;
  amountPaid: number;
  dueDate: string;
  status: string;
}

export interface TenantDashboard {
  nextPayment: TenantDashboardNextPayment | null;
  activeLease: TenantDashboardLeaseSummary | null;
  recentPayments: TenantDashboardPaymentSummary[];
}
