import { DatePipe } from '@angular/common';
import { Component, OnInit, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { MatChipsModule } from '@angular/material/chips';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { StatCardComponent } from '../../../../shared/components/stat-card/stat-card.component';
import { EmptyStateComponent } from '../../../../shared/components/empty-state/empty-state.component';
import { StatusLabelPipe } from '../../../../shared/pipes/status-label.pipe';
import { DashboardStore } from '../../store/dashboard.store';

@Component({
  selector: 'app-manager-dashboard',
  standalone: true,
  imports: [DatePipe, RouterLink, MatChipsModule, MatProgressSpinnerModule, StatCardComponent, EmptyStateComponent, StatusLabelPipe],
  templateUrl: './manager-dashboard.component.html',
  styleUrl: './manager-dashboard.component.scss',
})
export class ManagerDashboardComponent implements OnInit {
  readonly store = inject(DashboardStore);

  ngOnInit(): void {
    this.store.loadManager();
  }
}
