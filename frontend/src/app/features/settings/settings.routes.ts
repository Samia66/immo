import { Routes } from '@angular/router';
import { roleGuard } from '../../core/guards/role.guard';
import { RoleName } from '../../core/models/enums';

export const SETTINGS_ROUTES: Routes = [
  {
    path: 'organization',
    canActivate: [roleGuard([RoleName.ADMIN_AGENCE])],
    loadComponent: () =>
      import('./organization-settings/organization-settings.component').then((m) => m.OrganizationSettingsComponent),
    title: 'Organisation',
  },
  {
    path: 'users',
    canActivate: [roleGuard([RoleName.ADMIN_AGENCE])],
    loadComponent: () =>
      import('./users-management/users-management.component').then((m) => m.UsersManagementComponent),
    title: 'Utilisateurs',
  },
  {
    path: 'roles-permissions',
    canActivate: [roleGuard([RoleName.ADMIN_AGENCE])],
    loadComponent: () =>
      import('./roles-permissions/roles-permissions.component').then((m) => m.RolesPermissionsComponent),
    title: 'Rôles & permissions',
  },
  { path: '', redirectTo: 'organization', pathMatch: 'full' },
];
