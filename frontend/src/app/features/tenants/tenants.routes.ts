import { Routes } from '@angular/router';
import { permissionGuard } from '../../core/guards/permission.guard';

export const TENANTS_ROUTES: Routes = [
  {
    path: '',
    canActivate: [permissionGuard('tenants:read')],
    loadComponent: () => import('./pages/tenant-list/tenant-list.component').then((m) => m.TenantListComponent),
    title: 'Locataires',
  },
  {
    path: 'new',
    canActivate: [permissionGuard('tenants:create')],
    loadComponent: () => import('./pages/tenant-form/tenant-form.component').then((m) => m.TenantFormComponent),
    title: 'Nouveau locataire',
  },
  {
    path: ':id',
    canActivate: [permissionGuard('tenants:read')],
    loadComponent: () => import('./pages/tenant-form/tenant-form.component').then((m) => m.TenantFormComponent),
    title: 'Locataire',
  },
];
