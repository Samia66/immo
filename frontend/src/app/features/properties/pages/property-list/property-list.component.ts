import { Component, OnInit, TemplateRef, inject, viewChild } from '@angular/core';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatDialog } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { MatTooltipModule } from '@angular/material/tooltip';
import {
  DataTableColumn,
  DataTableComponent,
  PageChangeEvent,
  SortEvent,
} from '../../../../shared/components/data-table/data-table.component';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { ConfirmDialogComponent } from '../../../../shared/components/confirm-dialog/confirm-dialog.component';
import { HasPermissionDirective } from '../../../../shared/directives/has-permission.directive';
import { StatusLabelPipe } from '../../../../shared/pipes/status-label.pipe';
import { NotificationService } from '../../../../core/services/notification.service';
import { PropertyStatus } from '../../../../core/models/enums';
import { PropertiesStore } from '../../store/properties.store';
import { Property, PropertyFilters } from '../../models/property.model';
import { PropertiesApiService } from '../../services/properties-api.service';
import { PropertyFiltersComponent } from '../../components/property-filters/property-filters.component';

@Component({
  selector: 'app-property-list',
  standalone: true,
  imports: [
    DataTableComponent,
    PageHeaderComponent,
    PropertyFiltersComponent,
    HasPermissionDirective,
    MatButtonModule,
    MatIconModule,
    MatTooltipModule,
  ],
  templateUrl: './property-list.component.html',
  styleUrl: './property-list.component.scss',
})
export class PropertyListComponent implements OnInit {
  readonly store = inject(PropertiesStore);
  private readonly api = inject(PropertiesApiService);
  private readonly router = inject(Router);
  private readonly dialog = inject(MatDialog);
  private readonly notificationService = inject(NotificationService);
  private readonly statusLabelPipe = new StatusLabelPipe();

  readonly rowActionsRef = viewChild.required<TemplateRef<{ $implicit: Property }>>('rowActionsTpl');

  readonly columns: DataTableColumn<Property>[] = [
    { key: 'reference', header: 'Référence', sortable: true },
    { key: 'title', header: 'Titre', sortable: true },
    { key: 'city', header: 'Ville', sortable: true },
    { key: 'type', header: 'Type', value: (row) => this.statusLabelPipe.transform(row.type) },
    {
      key: 'units',
      header: 'Logements',
      value: (row) => this.unitsSummary(row),
    },
  ];

  /**
   * `GET /properties` includes each property's `units` array (see backend
   * PropertiesService.mapWithUnits), so the breakdown can be computed client-side without an
   * extra request per row. Falls back to a plain count if `units` is ever omitted.
   */
  private unitsSummary(property: Property): string {
    const units = property.units ?? [];
    if (!units.length) {
      return 'Aucun logement';
    }
    const occupied = units.filter((u) => u.status === PropertyStatus.OCCUPE).length;
    const available = units.filter((u) => u.status === PropertyStatus.DISPONIBLE).length;
    const label = units.length > 1 ? 'logements' : 'logement';
    return `${units.length} ${label} · ${occupied} occupé(s) · ${available} disponible(s)`;
  }

  ngOnInit(): void {
    this.store.load();
  }

  onFiltersChange(filters: PropertyFilters): void {
    this.store.setFilters(filters);
  }

  onPageChange(event: PageChangeEvent): void {
    this.store.setPage(event.page, event.limit);
  }

  onSortChange(event: SortEvent): void {
    this.store.setSort(event.sortBy, event.sortOrder);
  }

  openDetail(property: Property): void {
    this.router.navigate(['/app/properties', property.id]);
  }

  createNew(): void {
    this.router.navigate(['/app/properties/new']);
  }

  edit(property: Property): void {
    this.router.navigate(['/app/properties', property.id, 'edit']);
  }

  remove(property: Property): void {
    const ref = this.dialog.open(ConfirmDialogComponent, {
      data: {
        title: 'Supprimer le bien',
        message: `Confirmez-vous la suppression de "${property.title}" ?`,
        danger: true,
      },
    });
    ref.afterClosed().subscribe((confirmed) => {
      if (!confirmed) {
        return;
      }
      this.api.remove(property.id).subscribe({
        next: () => {
          this.notificationService.success('Bien supprimé.');
          this.store.invalidate();
        },
      });
    });
  }
}
