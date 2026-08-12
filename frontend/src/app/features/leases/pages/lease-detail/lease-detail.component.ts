import { DatePipe } from '@angular/common';
import { Component, OnInit, inject, signal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatChipsModule } from '@angular/material/chips';
import { MatDialog } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { EmptyStateComponent } from '../../../../shared/components/empty-state/empty-state.component';
import { ConfirmDialogComponent } from '../../../../shared/components/confirm-dialog/confirm-dialog.component';
import { HasPermissionDirective } from '../../../../shared/directives/has-permission.directive';
import { CurrencyXofPipe } from '../../../../shared/pipes/currency-xof.pipe';
import { StatusLabelPipe } from '../../../../shared/pipes/status-label.pipe';
import { NotificationService } from '../../../../core/services/notification.service';
import { LeasesStore } from '../../store/leases.store';
import { LeasesApiService } from '../../services/leases-api.service';
import { LeaseStatus } from '../../../../core/models/enums';

@Component({
  selector: 'app-lease-detail',
  standalone: true,
  imports: [
    DatePipe,
    MatButtonModule,
    MatChipsModule,
    MatIconModule,
    MatProgressSpinnerModule,
    HasPermissionDirective,
    PageHeaderComponent,
    EmptyStateComponent,
    CurrencyXofPipe,
    StatusLabelPipe,
  ],
  templateUrl: './lease-detail.component.html',
})
export class LeaseDetailComponent implements OnInit {
  readonly store = inject(LeasesStore);
  private readonly api = inject(LeasesApiService);
  private readonly route = inject(ActivatedRoute);
  private readonly dialog = inject(MatDialog);
  private readonly notificationService = inject(NotificationService);

  readonly leaseId = this.route.snapshot.paramMap.get('id') ?? '';
  readonly LeaseStatus = LeaseStatus;
  readonly processing = signal(false);

  ngOnInit(): void {
    this.store.loadOne(this.leaseId);
  }

  terminate(): void {
    const ref = this.dialog.open(ConfirmDialogComponent, {
      data: {
        title: 'Résilier le contrat',
        message: 'Cette action est définitive. Confirmez-vous la résiliation ?',
        danger: true,
      },
    });
    ref.afterClosed().subscribe((confirmed) => {
      if (!confirmed) return;
      this.processing.set(true);
      this.api
        .terminate(this.leaseId, { terminationDate: new Date().toISOString().slice(0, 10) })
        .subscribe({
          next: () => {
            this.notificationService.success('Contrat résilié.');
            this.processing.set(false);
            this.store.loadOne(this.leaseId);
          },
          error: () => this.processing.set(false),
        });
    });
  }

  downloadContract(): void {
    window.open(this.api.contractPdfUrl(this.leaseId), '_blank');
  }
}
