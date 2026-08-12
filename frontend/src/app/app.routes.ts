import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth.guard';
import { roleGuard } from './core/guards/role.guard';
import { RoleName } from './core/models/enums';

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'app/dashboard' },

  {
    path: 'auth',
    loadChildren: () => import('./features/auth/auth.routes').then((m) => m.AUTH_ROUTES),
  },

  {
    path: 'app',
    canActivate: [authGuard],
    loadComponent: () => import('./layout/shell/shell.component').then((m) => m.ShellComponent),
    children: [
      { path: '', pathMatch: 'full', redirectTo: 'dashboard' },
      {
        path: 'dashboard',
        loadChildren: () => import('./features/dashboard/dashboard.routes').then((m) => m.DASHBOARD_ROUTES),
      },
      {
        path: 'properties',
        loadChildren: () => import('./features/properties/properties.routes').then((m) => m.PROPERTIES_ROUTES),
      },
      {
        path: 'owners',
        loadChildren: () => import('./features/owners/owners.routes').then((m) => m.OWNERS_ROUTES),
      },
      {
        path: 'tenants',
        loadChildren: () => import('./features/tenants/tenants.routes').then((m) => m.TENANTS_ROUTES),
      },
      {
        path: 'leases',
        loadChildren: () => import('./features/leases/leases.routes').then((m) => m.LEASES_ROUTES),
      },
      {
        path: 'payments',
        loadChildren: () => import('./features/payments/payments.routes').then((m) => m.PAYMENTS_ROUTES),
      },
      {
        path: 'maintenance',
        loadChildren: () => import('./features/maintenance/maintenance.routes').then((m) => m.MAINTENANCE_ROUTES),
      },
      {
        path: 'notifications',
        loadChildren: () =>
          import('./features/notifications/notifications.routes').then((m) => m.NOTIFICATIONS_ROUTES),
      },
      {
        path: 'settings',
        canActivate: [roleGuard([RoleName.ADMIN_AGENCE])],
        loadChildren: () => import('./features/settings/settings.routes').then((m) => m.SETTINGS_ROUTES),
      },
    ],
  },

  {
    path: 'super-admin',
    canActivate: [authGuard, roleGuard([RoleName.SUPER_ADMIN])],
    loadComponent: () =>
      import('./features/super-admin/shell/super-admin-shell.component').then((m) => m.SuperAdminShellComponent),
    loadChildren: () => import('./features/super-admin/super-admin.routes').then((m) => m.SUPER_ADMIN_ROUTES),
  },

  { path: '**', redirectTo: 'app/dashboard' },
];
