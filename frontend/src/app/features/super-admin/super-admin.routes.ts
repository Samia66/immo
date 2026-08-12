import { Routes } from '@angular/router';

export const SUPER_ADMIN_ROUTES: Routes = [
  {
    path: 'organizations',
    loadComponent: () =>
      import('./pages/organizations-list/organizations-list.component').then((m) => m.OrganizationsListComponent),
    title: 'Organisations',
  },
  {
    path: 'organizations/:id',
    loadComponent: () =>
      import('./pages/organization-detail/organization-detail.component').then((m) => m.OrganizationDetailComponent),
    title: 'Détail organisation',
  },
  {
    path: 'statistics',
    loadComponent: () => import('./pages/statistics/statistics.component').then((m) => m.StatisticsComponent),
    title: 'Statistiques',
  },
  { path: '', redirectTo: 'organizations', pathMatch: 'full' },
];
