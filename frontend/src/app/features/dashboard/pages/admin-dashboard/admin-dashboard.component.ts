import { DatePipe } from '@angular/common';
import { Component, OnInit, computed, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { MatChipsModule } from '@angular/material/chips';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatTooltipModule } from '@angular/material/tooltip';
import { StatCardComponent } from '../../../../shared/components/stat-card/stat-card.component';
import { EmptyStateComponent } from '../../../../shared/components/empty-state/empty-state.component';
import { CurrencyXofPipe } from '../../../../shared/pipes/currency-xof.pipe';
import { StatusLabelPipe } from '../../../../shared/pipes/status-label.pipe';
import { DashboardStore } from '../../store/dashboard.store';

interface RevenueBar {
  month: string;
  amount: number;
  heightPct: number;
}

interface StatusSlice {
  status: string;
  count: number;
  pct: number;
}

/**
 * NOTE (simplification): per task scope, charting is done with plain CSS bars instead of a
 * charting library (ng2-charts/Chart.js were explicitly out of scope). The data contract
 * consumed here matches SPECIFICATION.md §11.2 (`GET /dashboard/admin`) exactly.
 */
@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  imports: [
    DatePipe,
    RouterLink,
    MatChipsModule,
    MatIconModule,
    MatProgressSpinnerModule,
    MatTooltipModule,
    StatCardComponent,
    EmptyStateComponent,
    CurrencyXofPipe,
    StatusLabelPipe,
  ],
  templateUrl: './admin-dashboard.component.html',
  styleUrl: './admin-dashboard.component.scss',
})
export class AdminDashboardComponent implements OnInit {
  readonly store = inject(DashboardStore);

  readonly revenueBars = computed<RevenueBar[]>(() => {
    const data = this.store.admin()?.revenueByMonth ?? [];
    const max = this.store.maxRevenueByMonth() || 1;
    return data.map((entry) => ({ ...entry, heightPct: Math.round((entry.amount / max) * 100) }));
  });

  readonly statusSlices = computed<StatusSlice[]>(() => {
    const data = this.store.admin()?.propertiesByStatus ?? [];
    const total = data.reduce((sum, entry) => sum + entry.count, 0) || 1;
    return data.map((entry) => ({ ...entry, pct: Math.round((entry.count / total) * 100) }));
  });

  ngOnInit(): void {
    this.store.loadAdmin();
  }
}
