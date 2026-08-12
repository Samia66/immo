import { Routes } from '@angular/router';
import { permissionGuard } from '../../core/guards/permission.guard';

export const OWNERS_ROUTES: Routes = [
  {
    path: '',
    canActivate: [permissionGuard('owners:read')],
    loadComponent: () => import('./pages/owner-list/owner-list.component').then((m) => m.OwnerListComponent),
    title: 'Propriétaires',
  },
  {
    path: 'new',
    canActivate: [permissionGuard('owners:create')],
    loadComponent: () => import('./pages/owner-form/owner-form.component').then((m) => m.OwnerFormComponent),
    title: 'Nouveau propriétaire',
  },
  {
    path: ':id',
    canActivate: [permissionGuard('owners:read')],
    loadComponent: () => import('./pages/owner-form/owner-form.component').then((m) => m.OwnerFormComponent),
    title: 'Propriétaire',
  },
];
