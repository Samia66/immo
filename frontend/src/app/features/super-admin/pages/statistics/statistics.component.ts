import { Component, OnInit, inject, signal } from '@angular/core';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { StatCardComponent } from '../../../../shared/components/stat-card/stat-card.component';
import { EmptyStateComponent } from '../../../../shared/components/empty-state/empty-state.component';
import { SuperAdminApiService } from '../../services/super-admin-api.service';
import { SuperAdminStatistics } from '../../models/super-admin.model';

@Component({
  selector: 'app-statistics',
  standalone: true,
  imports: [MatProgressSpinnerModule, PageHeaderComponent, StatCardComponent, EmptyStateComponent],
  templateUrl: './statistics.component.html',
})
export class StatisticsComponent implements OnInit {
  private readonly api = inject(SuperAdminApiService);

  readonly stats = signal<SuperAdminStatistics | null>(null);
  readonly loading = signal(true);

  ngOnInit(): void {
    this.api.getStatistics().subscribe({
      next: (stats) => {
        this.stats.set(stats);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }
}
