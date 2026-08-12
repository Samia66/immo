import { Injectable, computed, inject, signal } from '@angular/core';
import { PaginatedResult } from '../../../core/models';
import { PaymentsApiService } from '../services/payments-api.service';
import { Payment, PaymentQuery } from '../models/payment.model';
import { PaymentStatus } from '../../../core/models/enums';

@Injectable({ providedIn: 'root' })
export class PaymentsStore {
  private readonly api = inject(PaymentsApiService);

  private readonly _result = signal<PaginatedResult<Payment> | null>(null);
  private readonly _loading = signal(false);
  private readonly _status = signal<PaymentStatus | undefined>(undefined);
  private readonly _page = signal(1);
  private readonly _limit = signal(20);

  readonly result = this._result.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly payments = computed(() => this._result()?.data ?? []);

  load(): void {
    this._loading.set(true);
    const query: PaymentQuery = { status: this._status(), page: this._page(), limit: this._limit() };
    this.api.list(query).subscribe({
      next: (res) => {
        this._result.set(res);
        this._loading.set(false);
      },
      error: () => this._loading.set(false),
    });
  }

  setStatus(status: PaymentStatus | undefined): void {
    this._status.set(status);
    this._page.set(1);
    this.load();
  }

  setPage(page: number, limit: number): void {
    this._page.set(page);
    this._limit.set(limit);
    this.load();
  }

  invalidate(): void {
    this.load();
  }
}
