import { Component, OnInit, inject, signal } from '@angular/core';
import { DataTableColumn, DataTableComponent } from '../../../../shared/components/data-table/data-table.component';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { PaginatedResult } from '../../../../core/models';
import { PaymentsApiService } from '../../services/payments-api.service';
import { Payment } from '../../models/payment.model';

@Component({
  selector: 'app-payment-overdue',
  standalone: true,
  imports: [DataTableComponent, PageHeaderComponent],
  templateUrl: './payment-overdue.component.html',
})
export class PaymentOverdueComponent implements OnInit {
  private readonly api = inject(PaymentsApiService);

  readonly result = signal<PaginatedResult<Payment> | null>(null);
  readonly loading = signal(false);

  readonly columns: DataTableColumn<Payment>[] = [
    { key: 'lease', header: 'Bien', value: (row) => row.lease?.propertyTitle ?? row.leaseId },
    { key: 'tenant', header: 'Locataire', value: (row) => row.lease?.tenantName ?? '—' },
    { key: 'dueDate', header: 'Échéance', value: (row) => new Date(row.dueDate).toLocaleDateString('fr-FR') },
    { key: 'amountDue', header: 'Montant dû', align: 'end', value: (row) => `${row.amountDue}` },
    { key: 'lateFee', header: 'Pénalité', align: 'end', value: (row) => `${row.lateFee ?? 0}` },
  ];

  ngOnInit(): void {
    this.loading.set(true);
    this.api.overdue().subscribe({
      next: (res) => {
        this.result.set(res);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }
}
