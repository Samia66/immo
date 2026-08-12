import { Component, OnInit, TemplateRef, inject, signal, viewChild } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatDialog } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatTooltipModule } from '@angular/material/tooltip';
import { DataTableColumn, DataTableComponent } from '../../../shared/components/data-table/data-table.component';
import { PageHeaderComponent } from '../../../shared/components/page-header/page-header.component';
import { NotificationService } from '../../../core/services/notification.service';
import { PaginatedResult } from '../../../core/models';
import { User } from '../../../core/models/user.model';
import { SettingsApiService } from '../services/settings-api.service';
import { UserCreateDialogComponent } from './user-create-dialog.component';

@Component({
  selector: 'app-users-management',
  standalone: true,
  imports: [DataTableComponent, PageHeaderComponent, MatButtonModule, MatIconModule, MatSlideToggleModule, MatTooltipModule],
  templateUrl: './users-management.component.html',
})
export class UsersManagementComponent implements OnInit {
  private readonly api = inject(SettingsApiService);
  private readonly dialog = inject(MatDialog);
  private readonly notificationService = inject(NotificationService);

  readonly rowActionsRef = viewChild.required<TemplateRef<{ $implicit: User }>>('rowActionsTpl');

  readonly result = signal<PaginatedResult<User> | null>(null);
  readonly loading = signal(false);
  readonly page = signal(1);
  readonly limit = signal(20);

  readonly columns: DataTableColumn<User>[] = [
    { key: 'name', header: 'Nom', value: (row) => `${row.firstName} ${row.lastName}` },
    { key: 'email', header: 'Email' },
    { key: 'role', header: 'Rôle', value: (row) => row.role.label },
    { key: 'isActive', header: 'Actif', value: (row) => (row.isActive ? 'Oui' : 'Non') },
  ];

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.api.listUsers({ page: this.page(), limit: this.limit() }).subscribe({
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

  invite(): void {
    const ref = this.dialog.open(UserCreateDialogComponent, { width: '440px' });
    ref.afterClosed().subscribe((created) => {
      if (created) this.load();
    });
  }

  toggleActive(user: User): void {
    this.api.toggleUserActive(user.id).subscribe({
      next: () => {
        this.notificationService.success('Statut utilisateur mis à jour.');
        this.load();
      },
    });
  }
}
