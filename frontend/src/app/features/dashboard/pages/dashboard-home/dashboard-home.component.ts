import { Component, inject } from '@angular/core';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { EmptyStateComponent } from '../../../../shared/components/empty-state/empty-state.component';
import { AuthService } from '../../../../core/services/auth.service';
import { RoleName } from '../../../../core/models/enums';
import { AdminDashboardComponent } from '../admin-dashboard/admin-dashboard.component';
import { ManagerDashboardComponent } from '../manager-dashboard/manager-dashboard.component';
import { TenantDashboardComponent } from '../tenant-dashboard/tenant-dashboard.component';

/** Renders the dashboard variant matching the current user's role (spec §9: "redirige selon rôle"). */
@Component({
  selector: 'app-dashboard-home',
  standalone: true,
  imports: [PageHeaderComponent, EmptyStateComponent, AdminDashboardComponent, ManagerDashboardComponent, TenantDashboardComponent],
  templateUrl: './dashboard-home.component.html',
})
export class DashboardHomeComponent {
  private readonly authService = inject(AuthService);
  readonly RoleName = RoleName;

  readonly role = this.authService.role;
  readonly userName = this.authService.currentUser()
    ? `${this.authService.currentUser()!.firstName} ${this.authService.currentUser()!.lastName}`
    : '';
}
