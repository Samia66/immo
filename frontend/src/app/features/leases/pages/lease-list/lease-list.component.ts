import { Component, OnInit, TemplateRef, inject, viewChild } from '@angular/core';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';
import { MatTooltipModule } from '@angular/material/tooltip';
import { DataTableColumn, DataTableComponent } from '../../../../shared/components/data-table/data-table.component';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { HasPermissionDirective } from '../../../../shared/directives/has-permission.directive';
import { LeasesStore } from '../../store/leases.store';
import { Lease } from '../../models/lease.model';
import { LeaseStatus } from '../../../../core/models/enums';

@Component({
  selector: 'app-lease-list',
  standalone: true,
  imports: [
    DataTableComponent,
    PageHeaderComponent,
    HasPermissionDirective,
    MatButtonModule,
    MatFormFieldModule,
    MatIconModule,
    MatSelectModule,
    MatTooltipModule,
  ],
  templateUrl: './lease-list.component.html',
})
export class LeaseListComponent implements OnInit {
  readonly store = inject(LeasesStore);
  private readonly router = inject(Router);

  readonly rowActionsRef = viewChild.required<TemplateRef<{ $implicit: Lease }>>('rowActionsTpl');
  readonly statuses = Object.values(LeaseStatus);

  readonly columns: DataTableColumn<Lease>[] = [
    { key: 'reference', header: 'Référence' },
    {
      key: 'propertyUnit',
      header: 'Bien / Logement',
      value: (row) =>
        row.propertyUnit
          ? `${row.propertyUnit.property.title} — ${row.propertyUnit.label ?? row.propertyUnit.reference}`
          : row.propertyUnitId,
    },
    { key: 'tenant', header: 'Locataire', value: (row) => row.tenant?.fullName ?? row.tenantId },
    { key: 'startDate', header: 'Début', value: (row) => new Date(row.startDate).toLocaleDateString('fr-FR') },
    {
      key: 'endDate',
      header: 'Fin',
      value: (row) => (row.endDate ? new Date(row.endDate).toLocaleDateString('fr-FR') : '—'),
    },
    { key: 'rentAmount', header: 'Loyer', align: 'end', value: (row) => `${row.rentAmount}` },
    { key: 'status', header: 'Statut' },
  ];

  ngOnInit(): void {
    this.store.load();
  }

  onStatusChange(status: LeaseStatus | null): void {
    this.store.setStatus(status ?? undefined);
  }

  onPageChange(event: { page: number; limit: number }): void {
    this.store.setPage(event.page, event.limit);
  }

  createNew(): void {
    this.router.navigate(['/app/leases/new']);
  }

  openDetail(lease: Lease): void {
    this.router.navigate(['/app/leases', lease.id]);
  }
}
