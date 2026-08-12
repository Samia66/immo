import { Routes } from '@angular/router';
import { permissionGuard } from '../../core/guards/permission.guard';

export const MAINTENANCE_ROUTES: Routes = [
  {
    path: '',
    canActivate: [permissionGuard('maintenance:read')],
    loadComponent: () =>
      import('./pages/maintenance-list/maintenance-list.component').then((m) => m.MaintenanceListComponent),
    title: 'Maintenance',
  },
  {
    path: 'board',
    canActivate: [permissionGuard('maintenance:read')],
    loadComponent: () =>
      import('./pages/maintenance-board/maintenance-board.component').then((m) => m.MaintenanceBoardComponent),
    title: 'Maintenance — Kanban',
  },
  {
    path: 'new',
    canActivate: [permissionGuard('maintenance:create')],
    loadComponent: () =>
      import('./pages/maintenance-form/maintenance-form.component').then((m) => m.MaintenanceFormComponent),
    title: 'Nouvelle demande',
  },
  {
    path: ':id',
    canActivate: [permissionGuard('maintenance:read')],
    loadComponent: () =>
      import('./pages/maintenance-detail/maintenance-detail.component').then((m) => m.MaintenanceDetailComponent),
    title: 'Détail de la demande',
  },
];
