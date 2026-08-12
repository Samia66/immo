import { Routes } from '@angular/router';
import { permissionGuard } from '../../core/guards/permission.guard';

export const LEASES_ROUTES: Routes = [
  {
    path: '',
    canActivate: [permissionGuard('leases:read')],
    loadComponent: () => import('./pages/lease-list/lease-list.component').then((m) => m.LeaseListComponent),
    title: 'Contrats',
  },
  {
    path: 'new',
    canActivate: [permissionGuard('leases:create')],
    loadComponent: () => import('./pages/lease-form/lease-form.component').then((m) => m.LeaseFormComponent),
    title: 'Nouveau contrat',
  },
  {
    path: ':id',
    canActivate: [permissionGuard('leases:read')],
    loadComponent: () => import('./pages/lease-detail/lease-detail.component').then((m) => m.LeaseDetailComponent),
    title: 'Détail du contrat',
  },
];
