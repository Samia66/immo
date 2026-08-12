import { Injectable, computed, inject, signal } from '@angular/core';
import { PaginatedResult } from '../../../core/models';
import { MaintenanceApiService } from '../services/maintenance-api.service';
import { MaintenanceQuery, MaintenanceRequest } from '../models/maintenance.model';
import { MaintenanceStatus } from '../../../core/models/enums';

@Injectable({ providedIn: 'root' })
export class MaintenanceStore {
  private readonly api = inject(MaintenanceApiService);

  private readonly _result = signal<PaginatedResult<MaintenanceRequest> | null>(null);
  private readonly _loading = signal(false);
  private readonly _status = signal<MaintenanceStatus | undefined>(undefined);
  private readonly _page = signal(1);
  private readonly _limit = signal(20);
  private readonly _selected = signal<MaintenanceRequest | null>(null);

  readonly result = this._result.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly selected = this._selected.asReadonly();
  readonly requests = computed(() => this._result()?.data ?? []);

  load(): void {
    this._loading.set(true);
    const query: MaintenanceQuery = { status: this._status(), page: this._page(), limit: this._limit() };
    this.api.list(query).subscribe({
      next: (res) => {
        this._result.set(res);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }

  setStatus(status: MaintenanceStatus | undefined): void {
    this._status.set(status);
    this._page.set(1);
    this.load();
  }

  setPage(page: number, limit: number): void {
    this._page.set(page);
    this._limit.set(limit);
    this.load();
  }

  loadOne(id: string): void {
    this._loading.set(true);
    this.api.getById(id).subscribe({
      next: (request) => {
        this._selected.set(request);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }

  invalidate(): void {
    this.load();
  }

  /** Loads every request unpaginated for the kanban board view. */
  loadAllForBoard(): void {
    this._loading.set(true);
    this.api.list({ limit: 100 }).subscribe({
      next: (res) => {
        this._result.set(res);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }
}
