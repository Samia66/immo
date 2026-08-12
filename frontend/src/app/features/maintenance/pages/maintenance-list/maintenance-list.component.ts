import { Component, OnInit, TemplateRef, inject, viewChild } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';
import { MatTooltipModule } from '@angular/material/tooltip';
import { DataTableColumn, DataTableComponent } from '../../../../shared/components/data-table/data-table.component';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { HasPermissionDirective } from '../../../../shared/directives/has-permission.directive';
import { MaintenanceStore } from '../../store/maintenance.store';
import { MaintenanceRequest } from '../../models/maintenance.model';
import { MaintenanceStatus } from '../../../../core/models/enums';

@Component({
  selector: 'app-maintenance-list',
  standalone: true,
  imports: [
    RouterLink,
    DataTableComponent,
    PageHeaderComponent,
    HasPermissionDirective,
    MatButtonModule,
    MatFormFieldModule,
    MatIconModule,
    MatSelectModule,
    MatTooltipModule,
  ],
  templateUrl: './maintenance-list.component.html',
})
export class MaintenanceListComponent implements OnInit {
  readonly store = inject(MaintenanceStore);
  private readonly router = inject(Router);

  readonly rowActionsRef = viewChild.required<TemplateRef<{ $implicit: MaintenanceRequest }>>('rowActionsTpl');
  readonly statuses = Object.values(MaintenanceStatus);

  readonly columns: DataTableColumn<MaintenanceRequest>[] = [
    { key: 'property', header: 'Bien', value: (row) => row.property?.title ?? row.propertyId },
    { key: 'category', header: 'Catégorie' },
    { key: 'priority', header: 'Priorité' },
    { key: 'status', header: 'Statut' },
    {
      key: 'createdAt',
      header: 'Créée le',
      value: (row) => new Date(row.createdAt).toLocaleDateString('fr-FR'),
    },
  ];

  ngOnInit(): void {
    this.store.load();
  }

  onStatusChange(status: MaintenanceStatus | null): void {
    this.store.setStatus(status ?? undefined);
  }

  onPageChange(event: { page: number; limit: number }): void {
    this.store.setPage(event.page, event.limit);
  }

  createNew(): void {
    this.router.navigate(['/app/maintenance/new']);
  }

  openDetail(request: MaintenanceRequest): void {
    this.router.navigate(['/app/maintenance', request.id]);
  }
}
