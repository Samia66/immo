import { Component, OnInit, TemplateRef, inject, signal, viewChild } from '@angular/core';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTooltipModule } from '@angular/material/tooltip';
import { DataTableColumn, DataTableComponent } from '../../../../shared/components/data-table/data-table.component';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { NotificationService } from '../../../../core/services/notification.service';
import { Organization, PaginatedResult } from '../../../../core/models';
import { SuperAdminApiService } from '../../services/super-admin-api.service';

@Component({
  selector: 'app-organizations-list',
  standalone: true,
  imports: [DataTableComponent, PageHeaderComponent, MatButtonModule, MatIconModule, MatTooltipModule],
  templateUrl: './organizations-list.component.html',
})
export class OrganizationsListComponent implements OnInit {
  private readonly api = inject(SuperAdminApiService);
  private readonly router = inject(Router);
  private readonly notificationService = inject(NotificationService);

  readonly rowActionsRef = viewChild.required<TemplateRef<{ $implicit: Organization }>>('rowActionsTpl');

  readonly result = signal<PaginatedResult<Organization> | null>(null);
  readonly loading = signal(false);
  readonly page = signal(1);
  readonly limit = signal(20);

  readonly columns: DataTableColumn<Organization>[] = [
    { key: 'name', header: 'Nom', sortable: true },
    { key: 'code', header: 'Code' },
    { key: 'subscriptionPlan', header: 'Abonnement' },
    { key: 'isActive', header: 'Active', value: (row) => (row.isActive ? 'Oui' : 'Non') },
  ];

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.api.listOrganizations({ page: this.page(), limit: this.limit() }).subscribe({
      next: (res) => {
        this.result.set(res);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }

  onPageChange(event: { page: number; limit: number }): void {
    this.page.set(event.page);
    this.limit.set(event.limit);
    this.load();
  }

  openDetail(org: Organization): void {
    this.router.navigate(['/super-admin/organizations', org.id]);
  }

  toggleActive(org: Organization): void {
    this.api.toggleActive(org.id).subscribe({
      next: () => {
        this.notificationService.success('Statut mis à jour.');
        this.load();
      },
    });
  }
}
