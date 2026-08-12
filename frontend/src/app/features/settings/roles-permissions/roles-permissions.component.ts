import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatListModule } from '@angular/material/list';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { finalize } from 'rxjs';
import { PageHeaderComponent } from '../../../shared/components/page-header/page-header.component';
import { NotificationService } from '../../../core/services/notification.service';
import { Permission, Role } from '../../../core/models/user.model';
import { SettingsApiService } from '../services/settings-api.service';

interface PermissionModule {
  module: string;
  permissions: Permission[];
}

@Component({
  selector: 'app-roles-permissions',
  standalone: true,
  imports: [MatButtonModule, MatCheckboxModule, MatListModule, MatProgressSpinnerModule, PageHeaderComponent],
  templateUrl: './roles-permissions.component.html',
  styleUrl: './roles-permissions.component.scss',
})
export class RolesPermissionsComponent implements OnInit {
  private readonly api = inject(SettingsApiService);
  private readonly notificationService = inject(NotificationService);

  readonly roles = signal<Role[]>([]);
  readonly permissions = signal<Permission[]>([]);
  readonly selectedRoleId = signal<string | null>(null);
  readonly selectedPermissionCodes = signal<Set<string>>(new Set());
  readonly loading = signal(true);
  readonly saving = signal(false);

  readonly selectedRole = computed(() => this.roles().find((r) => r.id === this.selectedRoleId()) ?? null);

  readonly permissionsByModule = computed<PermissionModule[]>(() => {
    const groups = new Map<string, Permission[]>();
    for (const permission of this.permissions()) {
      const list = groups.get(permission.module) ?? [];
      list.push(permission);
      groups.set(permission.module, list);
    }
    return Array.from(groups.entries()).map(([module, permissions]) => ({ module, permissions }));
  });

  ngOnInit(): void {
    this.loading.set(true);
    this.api.listRoles().subscribe((roles) => {
      this.roles.set(roles);
      if (roles.length) {
        this.selectRole(roles[0]);
      }
      this.loading.set(false);
    });
    this.api.listPermissions().subscribe((permissions) => this.permissions.set(permissions));
  }

  selectRole(role: Role): void {
    this.selectedRoleId.set(role.id);
    this.selectedPermissionCodes.set(new Set((role.permissions ?? []).map((p) => p.code)));
  }

  isChecked(permission: Permission): boolean {
    return this.selectedPermissionCodes().has(permission.code);
  }

  toggle(permission: Permission): void {
    const next = new Set(this.selectedPermissionCodes());
    if (next.has(permission.code)) {
      next.delete(permission.code);
    } else {
      next.add(permission.code);
    }
    this.selectedPermissionCodes.set(next);
  }

  save(): void {
    const role = this.selectedRole();
    if (!role) {
      return;
    }
    const permissionIds = this.permissions()
      .filter((p) => this.selectedPermissionCodes().has(p.code))
      .map((p) => p.id);

    this.saving.set(true);
    this.api
      .updateRolePermissions(role.id, permissionIds)
      .pipe(finalize(() => this.saving.set(false)))
      .subscribe({ next: () => this.notificationService.success('Permissions mises à jour.') });
  }
}
