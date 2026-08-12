import { Component, OnInit, TemplateRef, inject, viewChild } from '@angular/core';
import { Router } from '@angular/router';
import { FormControl, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatDialog } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatTooltipModule } from '@angular/material/tooltip';
import { debounceTime } from 'rxjs';
import { DataTableColumn, DataTableComponent } from '../../../../shared/components/data-table/data-table.component';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { ConfirmDialogComponent } from '../../../../shared/components/confirm-dialog/confirm-dialog.component';
import { HasPermissionDirective } from '../../../../shared/directives/has-permission.directive';
import { NotificationService } from '../../../../core/services/notification.service';
import { TenantsStore } from '../../store/tenants.store';
import { Tenant } from '../../models/tenant.model';
import { TenantsApiService } from '../../services/tenants-api.service';

@Component({
  selector: 'app-tenant-list',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    DataTableComponent,
    PageHeaderComponent,
    HasPermissionDirective,
    MatButtonModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
    MatTooltipModule,
  ],
  templateUrl: './tenant-list.component.html',
})
export class TenantListComponent implements OnInit {
  readonly store = inject(TenantsStore);
  private readonly api = inject(TenantsApiService);
  private readonly router = inject(Router);
  private readonly dialog = inject(MatDialog);
  private readonly notificationService = inject(NotificationService);

  readonly rowActionsRef = viewChild.required<TemplateRef<{ $implicit: Tenant }>>('rowActionsTpl');
  readonly search = new FormControl('', { nonNullable: true });

  readonly columns: DataTableColumn<Tenant>[] = [
    { key: 'fullName', header: 'Nom', sortable: true },
    { key: 'phone', header: 'Téléphone' },
    { key: 'email', header: 'Email' },
    { key: 'profession', header: 'Profession' },
  ];

  ngOnInit(): void {
    this.store.load();
    this.search.valueChanges.pipe(debounceTime(350)).subscribe((value) => this.store.setSearch(value));
  }

  onPageChange(event: { page: number; limit: number }): void {
    this.store.setPage(event.page, event.limit);
  }

  createNew(): void {
    this.router.navigate(['/app/tenants/new']);
  }

  edit(tenant: Tenant): void {
    this.router.navigate(['/app/tenants', tenant.id]);
  }

  remove(tenant: Tenant): void {
    const ref = this.dialog.open(ConfirmDialogComponent, {
      data: { title: 'Supprimer le locataire', message: `Confirmez-vous la suppression de "${tenant.fullName}" ?`, danger: true },
    });
    ref.afterClosed().subscribe((confirmed) => {
      if (!confirmed) return;
      this.api.remove(tenant.id).subscribe(() => {
        this.notificationService.success('Locataire supprimé.');
        this.store.invalidate();
      });
    });
  }
}
