import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { PaginatedResult } from '../../../core/models';
import { CreateLeaseDto, Lease, LeaseQuery, TerminateLeaseDto } from '../models/lease.model';

@Injectable({ providedIn: 'root' })
export class LeasesApiService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/leases`;

  list(query: LeaseQuery = {}): Observable<PaginatedResult<Lease>> {
    let params = new HttpParams();
    for (const [key, value] of Object.entries(query)) {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    }
    return this.http.get<PaginatedResult<Lease>>(this.baseUrl, { params });
  }

  getById(id: string): Observable<Lease> {
    return this.http.get<Lease>(`${this.baseUrl}/${id}`);
  }

  create(dto: CreateLeaseDto): Observable<Lease> {
    return this.http.post<Lease>(this.baseUrl, dto);
  }

  update(id: string, dto: Partial<CreateLeaseDto>): Observable<Lease> {
    return this.http.patch<Lease>(`${this.baseUrl}/${id}`, dto);
  }

  renew(id: string, endDate: string): Observable<Lease> {
    return this.http.post<Lease>(`${this.baseUrl}/${id}/renew`, { endDate });
  }

  terminate(id: string, dto: TerminateLeaseDto): Observable<Lease> {
    return this.http.post<Lease>(`${this.baseUrl}/${id}/terminate`, dto);
  }

  expiringSoon(days = 30): Observable<Lease[]> {
    return this.http.get<Lease[]>(`${this.baseUrl}/expiring-soon`, { params: { days } as unknown as Record<string, string> });
  }

  contractPdfUrl(id: string): string {
    return `${this.baseUrl}/${id}/contract.pdf`;
  }
}
