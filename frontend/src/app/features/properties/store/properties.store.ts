import { Injectable, computed, inject, signal } from '@angular/core';
import { PaginatedResult } from '../../../core/models';
import { PropertyStatus } from '../../../core/models/enums';
import { PropertiesApiService } from '../services/properties-api.service';
import { Property, PropertyFilters, PropertyQuery } from '../models/property.model';

/**
 * Signals-based store for the properties feature — follows the convention documented in
 * SPECIFICATION.md §4 (no NgRx: plain signals + computed()).
 */
@Injectable({ providedIn: 'root' })
export class PropertiesStore {
  private readonly api = inject(PropertiesApiService);

  private readonly _result = signal<PaginatedResult<Property> | null>(null);
  private readonly _loading = signal(false);
  private readonly _filters = signal<PropertyFilters>({});
  private readonly _page = signal(1);
  private readonly _limit = signal(20);
  private readonly _sortBy = signal<string | undefined>(undefined);
  private readonly _sortOrder = signal<'asc' | 'desc'>('desc');
  private readonly _selected = signal<Property | null>(null);

  readonly result = this._result.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly filters = this._filters.asReadonly();
  readonly page = this._page.asReadonly();
  readonly selected = this._selected.asReadonly();

  readonly properties = computed(() => this._result()?.data ?? []);
  /**
   * "Available" no longer makes sense at the Property level (status moved to PropertyUnit) —
   * count properties that have at least one unit currently DISPONIBLE instead. Relies on the
   * list response including `units` (it does — see PropertiesService.mapWithUnits on the backend).
   */
  readonly availableCount = computed(
    () => this.properties().filter((p) => p.units?.some((u) => u.status === PropertyStatus.DISPONIBLE)).length,
  );

  load(): void {
    this._loading.set(true);
    const query: PropertyQuery = {
      ...this._filters(),
      page: this._page(),
      limit: this._limit(),
      sortBy: this._sortBy(),
      sortOrder: this._sortOrder(),
    };
    this.api.list(query).subscribe({
      next: (res) => {
        this._result.set(res);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }

  setFilters(filters: PropertyFilters): void {
    this._filters.set(filters);
    this._page.set(1);
    this.load();
  }

  setPage(page: number, limit: number): void {
    this._page.set(page);
    this._limit.set(limit);
    this.load();
  }

  setSort(sortBy: string, sortOrder: 'asc' | 'desc'): void {
    this._sortBy.set(sortBy);
    this._sortOrder.set(sortOrder);
    this.load();
  }

  loadOne(id: string): void {
    this._loading.set(true);
    this.api.getById(id).subscribe({
      next: (property) => {
        this._selected.set(property);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }

  clearSelected(): void {
    this._selected.set(null);
  }

  invalidate(): void {
    this.load();
  }
}
