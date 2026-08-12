import { Injectable, computed, inject, signal } from '@angular/core';
import { PaginatedResult } from '../../../core/models';
import { LeasesApiService } from '../services/leases-api.service';
import { Lease, LeaseQuery } from '../models/lease.model';
import { LeaseStatus } from '../../../core/models/enums';

@Injectable({ providedIn: 'root' })
export class LeasesStore {
  private readonly api = inject(LeasesApiService);

  private readonly _result = signal<PaginatedResult<Lease> | null>(null);
  private readonly _loading = signal(false);
  private readonly _status = signal<LeaseStatus | undefined>(undefined);
  private readonly _page = signal(1);
  private readonly _limit = signal(20);
  private readonly _selected = signal<Lease | null>(null);

  readonly result = this._result.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly selected = this._selected.asReadonly();
  readonly leases = computed(() => this._result()?.data ?? []);
  readonly activeCount = computed(() => this.leases().filter((l) => l.status === LeaseStatus.ACTIF).length);

  load(): void {
    this._loading.set(true);
    const query: LeaseQuery = { status: this._status(), page: this._page(), limit: this._limit() };
    this.api.list(query).subscribe({
      next: (res) => {
        this._result.set(res);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }

  setStatus(status: LeaseStatus | undefined): void {
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
      next: (lease) => {
        this._selected.set(lease);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }

  invalidate(): void {
    this.load();
  }
}
