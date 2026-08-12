import { Routes } from '@angular/router';
import { permissionGuard } from '../../core/guards/permission.guard';

export const PROPERTIES_ROUTES: Routes = [
  {
    path: '',
    canActivate: [permissionGuard('properties:read')],
    loadComponent: () =>
      import('./pages/property-list/property-list.component').then((m) => m.PropertyListComponent),
    title: 'Biens',
  },
  {
    path: 'new',
    canActivate: [permissionGuard('properties:create')],
    loadComponent: () =>
      import('./pages/property-form/property-form.component').then((m) => m.PropertyFormComponent),
    title: 'Nouveau bien',
  },
  {
    path: ':id',
    canActivate: [permissionGuard('properties:read')],
    loadComponent: () =>
      import('./pages/property-detail/property-detail.component').then((m) => m.PropertyDetailComponent),
    title: 'Détail du bien',
  },
  {
    path: ':id/edit',
    canActivate: [permissionGuard('properties:update')],
    loadComponent: () =>
      import('./pages/property-form/property-form.component').then((m) => m.PropertyFormComponent),
    title: 'Modifier le bien',
  },
];
