import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { PaginatedResult } from '../../../core/models';
import { Payment, PaymentQuery, RecordPaymentDto } from '../models/payment.model';

@Injectable({ providedIn: 'root' })
export class PaymentsApiService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/payments`;

  list(query: PaymentQuery = {}): Observable<PaginatedResult<Payment>> {
    let params = new HttpParams();
    for (const [key, value] of Object.entries(query)) {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    }
    return this.http.get<PaginatedResult<Payment>>(this.baseUrl, { params });
  }

  getById(id: string): Observable<Payment> {
    return this.http.get<Payment>(`${this.baseUrl}/${id}`);
  }

  record(id: string, dto: Omit<RecordPaymentDto, 'leaseId'>): Observable<Payment> {
    return this.http.post<Payment>(`${this.baseUrl}/${id}/record`, dto);
  }

  overdue(): Observable<PaginatedResult<Payment>> {
    return this.http.get<PaginatedResult<Payment>>(`${this.baseUrl}/overdue`);
  }

  me(): Observable<PaginatedResult<Payment>> {
    return this.http.get<PaginatedResult<Payment>>(`${this.baseUrl}/me`);
  }

  receiptUrl(id: string): string {
    return `${this.baseUrl}/${id}/receipt.pdf`;
  }
}
