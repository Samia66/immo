import { DatePipe } from '@angular/common';
import { Component, OnInit, inject, signal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatDialog } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { finalize } from 'rxjs';
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
import { LeaseInviteDialogComponent } from '../../dialogs/lease-invite-dialog/lease-invite-dialog.component';
import { LeaseRenewDialogComponent } from '../../dialogs/lease-renew-dialog/lease-renew-dialog.component';

/** Statuses from which a manager may still cancel a not-yet-active lease. */
const CANCELLABLE_STATUSES: LeaseStatus[] = [LeaseStatus.BROUILLON, LeaseStatus.ENVOYE, LeaseStatus.CONSULTE];

/** Maps each of the 9 lease states to a `data-accent` bucket (mirrors stat-card.component.scss). */
const STATUS_ACCENT: Record<LeaseStatus, 'neutral' | 'info' | 'success' | 'warn'> = {
  [LeaseStatus.BROUILLON]: 'neutral',
  [LeaseStatus.ENVOYE]: 'info',
  [LeaseStatus.CONSULTE]: 'info',
  [LeaseStatus.ACCEPTE]: 'info',
  [LeaseStatus.ACTIF]: 'success',
  [LeaseStatus.REFUSE]: 'warn',
  [LeaseStatus.ANNULE]: 'warn',
  [LeaseStatus.EXPIRE]: 'warn',
  [LeaseStatus.RESILIE]: 'warn',
};

@Component({
  selector: 'app-lease-detail',
  standalone: true,
  imports: [
    DatePipe,
    MatButtonModule,
    MatIconModule,
    MatProgressSpinnerModule,
    HasPermissionDirective,
    PageHeaderComponent,
    EmptyStateComponent,
    CurrencyXofPipe,
    StatusLabelPipe,
  ],
  templateUrl: './lease-detail.component.html',
  styleUrl: './lease-detail.component.scss',
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

  statusAccent(status: LeaseStatus): string {
    return STATUS_ACCENT[status] ?? 'neutral';
  }

  canCancel(status: LeaseStatus): boolean {
    return CANCELLABLE_STATUSES.includes(status);
  }

  send(): void {
    this.processing.set(true);
    this.api
      .send(this.leaseId)
      .pipe(finalize(() => this.processing.set(false)))
      .subscribe({
        next: () => {
          this.notificationService.success('Contrat envoyé au locataire.');
          this.store.loadOne(this.leaseId);
        },
      });
  }

  cancel(): void {
    const ref = this.dialog.open(ConfirmDialogComponent, {
      data: {
        title: 'Annuler le contrat',
        message: 'Cette action est définitive. Confirmez-vous l\'annulation ?',
        danger: true,
      },
    });
    ref.afterClosed().subscribe((confirmed) => {
      if (!confirmed) return;
      this.processing.set(true);
      this.api
        .cancel(this.leaseId)
        .pipe(finalize(() => this.processing.set(false)))
        .subscribe({
          next: () => {
            this.notificationService.success('Contrat annulé.');
            this.store.loadOne(this.leaseId);
          },
        });
    });
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
        .pipe(finalize(() => this.processing.set(false)))
        .subscribe({
          next: () => {
            this.notificationService.success('Contrat résilié.');
            this.store.loadOne(this.leaseId);
          },
        });
    });
  }

  renew(): void {
    const ref = this.dialog.open(LeaseRenewDialogComponent, { width: '420px' });
    ref.afterClosed().subscribe((result) => {
      if (!result) return;
      this.processing.set(true);
      this.api
        .renew(this.leaseId, result.newEndDate)
        .pipe(finalize(() => this.processing.set(false)))
        .subscribe({
          next: () => {
            this.notificationService.success('Contrat renouvelé.');
            this.store.loadOne(this.leaseId);
          },
        });
    });
  }

  invite(): void {
    this.processing.set(true);
    this.api
      .invite(this.leaseId)
      .pipe(finalize(() => this.processing.set(false)))
      .subscribe({
        next: (result) => {
          this.dialog.open(LeaseInviteDialogComponent, { width: '480px', data: result });
        },
      });
  }

  downloadContract(): void {
    window.open(this.api.contractPdfUrl(this.leaseId), '_blank');
  }
}
