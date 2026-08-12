import { Component, OnInit, inject, signal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatChipsModule } from '@angular/material/chips';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { EmptyStateComponent } from '../../../../shared/components/empty-state/empty-state.component';
import { HasPermissionDirective } from '../../../../shared/directives/has-permission.directive';
import { StatusLabelPipe } from '../../../../shared/pipes/status-label.pipe';
import { NotificationService } from '../../../../core/services/notification.service';
import { MaintenanceStatus } from '../../../../core/models/enums';
import { MaintenanceStore } from '../../store/maintenance.store';
import { MaintenanceApiService } from '../../services/maintenance-api.service';

const NEXT_STATUS: Record<MaintenanceStatus, MaintenanceStatus[]> = {
  [MaintenanceStatus.NOUVELLE]: [MaintenanceStatus.VALIDEE],
  [MaintenanceStatus.VALIDEE]: [MaintenanceStatus.ASSIGNEE],
  [MaintenanceStatus.ASSIGNEE]: [MaintenanceStatus.EN_COURS],
  [MaintenanceStatus.EN_COURS]: [MaintenanceStatus.TERMINEE],
  [MaintenanceStatus.TERMINEE]: [MaintenanceStatus.CLOTUREE],
  [MaintenanceStatus.CLOTUREE]: [],
};

@Component({
  selector: 'app-maintenance-detail',
  standalone: true,
  imports: [
    MatButtonModule,
    MatChipsModule,
    MatFormFieldModule,
    MatIconModule,
    MatProgressSpinnerModule,
    MatSelectModule,
    HasPermissionDirective,
    PageHeaderComponent,
    EmptyStateComponent,
    StatusLabelPipe,
  ],
  templateUrl: './maintenance-detail.component.html',
})
export class MaintenanceDetailComponent implements OnInit {
  readonly store = inject(MaintenanceStore);
  private readonly api = inject(MaintenanceApiService);
  private readonly route = inject(ActivatedRoute);
  private readonly notificationService = inject(NotificationService);

  readonly requestId = this.route.snapshot.paramMap.get('id') ?? '';
  readonly processing = signal(false);

  ngOnInit(): void {
    this.store.loadOne(this.requestId);
  }

  nextStatuses(): MaintenanceStatus[] {
    const current = this.store.selected()?.status;
    return current ? NEXT_STATUS[current] : [];
  }

  changeStatus(status: MaintenanceStatus): void {
    this.processing.set(true);
    this.api.updateStatus(this.requestId, { status }).subscribe({
      next: () => {
        this.notificationService.success('Statut mis à jour.');
        this.processing.set(false);
        this.store.loadOne(this.requestId);
      },
      error: () => this.processing.set(false),
    });
  }
}
