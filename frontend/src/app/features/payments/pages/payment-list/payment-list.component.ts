import { Component, OnInit, TemplateRef, inject, viewChild } from '@angular/core';
import { RouterLink } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatDialog } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';
import { MatTooltipModule } from '@angular/material/tooltip';
import { DataTableColumn, DataTableComponent } from '../../../../shared/components/data-table/data-table.component';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { HasPermissionDirective } from '../../../../shared/directives/has-permission.directive';
import { PaymentsStore } from '../../store/payments.store';
import { Payment } from '../../models/payment.model';
import { PaymentsApiService } from '../../services/payments-api.service';
import { PaymentStatus } from '../../../../core/models/enums';
import { PaymentRecordDialogComponent } from '../payment-record/payment-record-dialog.component';

@Component({
  selector: 'app-payment-list',
  standalone: true,
  imports: [
    RouterLink,
    DataTableComponent,
    PageHeaderComponent,
    HasPermissionDirective,
    MatButtonModule,
    MatFormFieldModule,
    MatIconModule,
    MatSelectModule,
    MatTooltipModule,
  ],
  templateUrl: './payment-list.component.html',
})
export class PaymentListComponent implements OnInit {
  readonly store = inject(PaymentsStore);
  private readonly api = inject(PaymentsApiService);
  private readonly dialog = inject(MatDialog);

  readonly rowActionsRef = viewChild.required<TemplateRef<{ $implicit: Payment }>>('rowActionsTpl');
  readonly statuses = Object.values(PaymentStatus);
  readonly PaymentStatus = PaymentStatus;

  readonly columns: DataTableColumn<Payment>[] = [
    { key: 'lease', header: 'Bien', value: (row) => row.lease?.propertyTitle ?? row.leaseId },
    { key: 'tenant', header: 'Locataire', value: (row) => row.lease?.tenantName ?? '—' },
    { key: 'dueDate', header: 'Échéance', value: (row) => new Date(row.dueDate).toLocaleDateString('fr-FR') },
    { key: 'amountDue', header: 'Montant dû', align: 'end', value: (row) => `${row.amountDue}` },
    { key: 'amountPaid', header: 'Montant payé', align: 'end', value: (row) => `${row.amountPaid}` },
    { key: 'status', header: 'Statut' },
  ];

  ngOnInit(): void {
    this.store.load();
  }

  onStatusChange(status: PaymentStatus | null): void {
    this.store.setStatus(status ?? undefined);
  }

  onPageChange(event: { page: number; limit: number }): void {
    this.store.setPage(event.page, event.limit);
  }

  record(payment: Payment): void {
    const ref = this.dialog.open(PaymentRecordDialogComponent, { width: '420px', data: { payment } });
    ref.afterClosed().subscribe((changed) => {
      if (changed) {
        this.store.invalidate();
      }
    });
  }

  downloadReceipt(payment: Payment): void {
    window.open(this.api.receiptUrl(payment.id), '_blank');
  }
}
