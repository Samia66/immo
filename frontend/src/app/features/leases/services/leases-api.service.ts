import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { PaginatedResult } from '../../../core/models';
import {
  CreateLeaseDto,
  InvitationResult,
  Lease,
  LeaseQuery,
  RefuseLeaseDto,
  TerminateLeaseDto,
} from '../models/lease.model';

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

  renew(id: string, newEndDate: string): Observable<Lease> {
    return this.http.post<Lease>(`${this.baseUrl}/${id}/renew`, { newEndDate });
  }

  terminate(id: string, dto: TerminateLeaseDto): Observable<Lease> {
    return this.http.post<Lease>(`${this.baseUrl}/${id}/terminate`, dto);
  }

  /** BROUILLON -> ENVOYE (manager action). */
  send(id: string): Observable<Lease> {
    return this.http.post<Lease>(`${this.baseUrl}/${id}/send`, {});
  }

  /** ENVOYE -> CONSULTE (tenant-side in the mobile app; kept here for API symmetry). */
  acknowledge(id: string): Observable<Lease> {
    return this.http.post<Lease>(`${this.baseUrl}/${id}/acknowledge`, {});
  }

  /** -> ACTIF directly, cascading through ACCEPTE (tenant-side; kept here for API symmetry). */
  accept(id: string): Observable<Lease> {
    return this.http.post<Lease>(`${this.baseUrl}/${id}/accept`, {});
  }

  /** Tenant-side refusal; kept here for API symmetry. */
  refuse(id: string, dto: RefuseLeaseDto): Observable<Lease> {
    return this.http.post<Lease>(`${this.baseUrl}/${id}/refuse`, dto);
  }

  /** BROUILLON/ENVOYE/CONSULTE -> ANNULE (manager action). */
  cancel(id: string): Observable<Lease> {
    return this.http.post<Lease>(`${this.baseUrl}/${id}/cancel`, {});
  }

  /** (Re)generates an activation invitation for this lease's tenant (manager action). */
  invite(id: string): Observable<InvitationResult> {
    return this.http.post<InvitationResult>(`${this.baseUrl}/${id}/invite`, {});
  }

  expiringSoon(days = 30): Observable<Lease[]> {
    return this.http.get<Lease[]>(`${this.baseUrl}/expiring-soon`, { params: { days } as unknown as Record<string, string> });
  }

  contractPdfUrl(id: string): string {
    return `${this.baseUrl}/${id}/contract.pdf`;
  }
}
