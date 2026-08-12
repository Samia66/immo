import { Routes } from '@angular/router';
import { permissionGuard } from '../../core/guards/permission.guard';

export const PAYMENTS_ROUTES: Routes = [
  {
    path: '',
    canActivate: [permissionGuard('payments:read')],
    loadComponent: () => import('./pages/payment-list/payment-list.component').then((m) => m.PaymentListComponent),
    title: 'Paiements',
  },
  {
    path: 'overdue',
    canActivate: [permissionGuard('payments:read')],
    loadComponent: () =>
      import('./pages/payment-list/payment-overdue.component').then((m) => m.PaymentOverdueComponent),
    title: 'Impayés',
  },
];
