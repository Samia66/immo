import { Injectable, computed, inject, signal } from '@angular/core';
import { PaginatedResult } from '../../../core/models';
import { TenantsApiService } from '../services/tenants-api.service';
import { Tenant, TenantQuery } from '../models/tenant.model';

@Injectable({ providedIn: 'root' })
export class TenantsStore {
  private readonly api = inject(TenantsApiService);

  private readonly _result = signal<PaginatedResult<Tenant> | null>(null);
  private readonly _loading = signal(false);
  private readonly _search = signal('');
  private readonly _page = signal(1);
  private readonly _limit = signal(20);

  readonly result = this._result.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly tenants = computed(() => this._result()?.data ?? []);

  load(): void {
    this._loading.set(true);
    const query: TenantQuery = { search: this._search() || undefined, page: this._page(), limit: this._limit() };
    this.api.list(query).subscribe({
      next: (res) => {
        this._result.set(res);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }

  setSearch(search: string): void {
    this._search.set(search);
    this._page.set(1);
    this.load();
  }

  setPage(page: number, limit: number): void {
    this._page.set(page);
    this._limit.set(limit);
    this.load();
  }

  invalidate(): void {
    this.load();
  }
}
