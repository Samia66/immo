import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { finalize } from 'rxjs';
import { PaymentMethod } from '../../../../core/models/enums';
import { NotificationService } from '../../../../core/services/notification.service';
import { PaymentsApiService } from '../../services/payments-api.service';
import { Payment } from '../../models/payment.model';

export interface PaymentRecordDialogData {
  payment: Payment;
}

@Component({
  selector: 'app-payment-record-dialog',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    MatDialogModule,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    MatProgressSpinnerModule,
    MatSelectModule,
  ],
  templateUrl: './payment-record-dialog.component.html',
})
export class PaymentRecordDialogComponent {
  readonly dialogRef = inject(MatDialogRef<PaymentRecordDialogComponent>);
  readonly data: PaymentRecordDialogData = inject(MAT_DIALOG_DATA);
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(PaymentsApiService);
  private readonly notificationService = inject(NotificationService);

  readonly methods = Object.values(PaymentMethod);
  readonly saving = signal(false);

  readonly form = this.fb.nonNullable.group({
    amountPaid: [
      this.data.payment.amountDue - this.data.payment.amountPaid,
      [Validators.required, Validators.min(0.01)],
    ],
    method: [PaymentMethod.ESPECES, [Validators.required]],
    transactionRef: [''],
    paidAt: [new Date().toISOString().slice(0, 10), [Validators.required]],
  });

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const raw = this.form.getRawValue();
    this.saving.set(true);
    this.api
      .record(this.data.payment.id, {
        amountPaid: raw.amountPaid,
        method: raw.method,
        transactionRef: raw.transactionRef || undefined,
        paidAt: raw.paidAt,
      })
      .pipe(finalize(() => this.saving.set(false)))
      .subscribe({
        next: () => {
          this.notificationService.success('Paiement enregistré.');
          this.dialogRef.close(true);
        },
      });
  }
}
