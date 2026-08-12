import { NgTemplateOutlet } from '@angular/common';
import { Component, TemplateRef, input, output, signal } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { PaginatedResult } from '../../../core/models';
import { EmptyStateComponent } from '../empty-state/empty-state.component';

export interface DataTableColumn<T> {
  key: string;
  header: string;
  value?: (row: T) => string;
  sortable?: boolean;
  align?: 'start' | 'end' | 'center';
}

export interface SortEvent {
  sortBy: string;
  sortOrder: 'asc' | 'desc';
}

export interface PageChangeEvent {
  page: number;
  limit: number;
}

/**
 * Generic paginated table. Every feature list page (properties, owners, tenants, leases,
 * payments, maintenance, ...) reuses this component with a column config and a
 * `PaginatedResult<T>` fed by its store.
 */
@Component({
  selector: 'app-data-table',
  standalone: true,
  imports: [MatPaginatorModule, MatProgressBarModule, MatIconModule, NgTemplateOutlet, EmptyStateComponent],
  templateUrl: './data-table.component.html',
  styleUrl: './data-table.component.scss',
})
export class DataTableComponent<T extends { id: string }> {
  readonly columns = input.required<DataTableColumn<T>[]>();
  readonly result = input<PaginatedResult<T> | null>(null);
  readonly loading = input(false);
  readonly pageSizeOptions = input<number[]>([10, 20, 50]);
  readonly emptyMessage = input('Aucun élément à afficher.');
  /** Optional template rendered in a trailing "actions" cell, with `let-row` context. */
  readonly rowActions = input<TemplateRef<{ $implicit: T }> | null>(null);

  readonly pageChange = output<PageChangeEvent>();
  readonly sortChange = output<SortEvent>();
  readonly rowClick = output<T>();

  readonly sortKey = signal<string | null>(null);
  readonly sortDir = signal<'asc' | 'desc'>('desc');

  onPage(event: PageEvent): void {
    this.pageChange.emit({ page: event.pageIndex + 1, limit: event.pageSize });
  }

  onSort(col: DataTableColumn<T>): void {
    if (!col.sortable) {
      return;
    }
    if (this.sortKey() === col.key) {
      this.sortDir.set(this.sortDir() === 'asc' ? 'desc' : 'asc');
    } else {
      this.sortKey.set(col.key);
      this.sortDir.set('asc');
    }
    this.sortChange.emit({ sortBy: col.key, sortOrder: this.sortDir() });
  }

  cellValue(col: DataTableColumn<T>, row: T): string {
    if (col.value) {
      return col.value(row);
    }
    const raw = (row as unknown as Record<string, unknown>)[col.key];
    return raw === null || raw === undefined ? '' : String(raw);
  }
}
