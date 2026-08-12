import { DatePipe } from '@angular/common';
import { Component, OnInit, inject } from '@angular/core';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatChipsModule } from '@angular/material/chips';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { EmptyStateComponent } from '../../../../shared/components/empty-state/empty-state.component';
import { CurrencyXofPipe } from '../../../../shared/pipes/currency-xof.pipe';
import { StatusLabelPipe } from '../../../../shared/pipes/status-label.pipe';
import { DashboardStore } from '../../store/dashboard.store';

@Component({
  selector: 'app-tenant-dashboard',
  standalone: true,
  imports: [
    DatePipe,
    MatButtonModule,
    MatChipsModule,
    MatIconModule,
    MatProgressSpinnerModule,
    EmptyStateComponent,
    CurrencyXofPipe,
    StatusLabelPipe,
  ],
  templateUrl: './tenant-dashboard.component.html',
})
export class TenantDashboardComponent implements OnInit {
  readonly store = inject(DashboardStore);
  private readonly router = inject(Router);

  ngOnInit(): void {
    this.store.loadTenant();
  }

  reportIssue(): void {
    this.router.navigate(['/app/maintenance/new']);
  }
}
