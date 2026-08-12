import { Injectable, computed, inject, signal } from '@angular/core';
import { DashboardApiService } from '../services/dashboard-api.service';
import { AdminDashboard, ManagerDashboard, TenantDashboard } from '../models/dashboard.model';

/**
 * Signals-based store for dashboard data. Loaded once per page visit; downstream components
 * consume derived `computed()` values (per SPECIFICATION.md §11.2).
 */
@Injectable({ providedIn: 'root' })
export class DashboardStore {
  private readonly api = inject(DashboardApiService);

  private readonly _admin = signal<AdminDashboard | null>(null);
  private readonly _manager = signal<ManagerDashboard | null>(null);
  private readonly _tenant = signal<TenantDashboard | null>(null);
  private readonly _loading = signal(false);

  readonly admin = this._admin.asReadonly();
  readonly manager = this._manager.asReadonly();
  readonly tenant = this._tenant.asReadonly();
  readonly loading = this._loading.asReadonly();

  readonly maxRevenueByMonth = computed(() => {
    const data = this._admin()?.revenueByMonth ?? [];
    return data.reduce((max, entry) => Math.max(max, entry.amount), 0);
  });

  loadAdmin(): void {
    this._loading.set(true);
    this.api.getAdmin().subscribe({
      next: (data) => {
        this._admin.set(data);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }

  loadManager(): void {
    this._loading.set(true);
    this.api.getManager().subscribe({
      next: (data) => {
        this._manager.set(data);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }

  loadTenant(): void {
    this._loading.set(true);
    this.api.getTenant().subscribe({
      next: (data) => {
        this._tenant.set(data);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }
}
