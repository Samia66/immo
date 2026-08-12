import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { PaginatedResult } from '../../../core/models';
import { CreateTenantDto, Tenant, TenantQuery, UpdateTenantDto } from '../models/tenant.model';

@Injectable({ providedIn: 'root' })
export class TenantsApiService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/tenants`;

  list(query: TenantQuery = {}): Observable<PaginatedResult<Tenant>> {
    let params = new HttpParams();
    for (const [key, value] of Object.entries(query)) {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    }
    return this.http.get<PaginatedResult<Tenant>>(this.baseUrl, { params });
  }

  getById(id: string): Observable<Tenant> {
    return this.http.get<Tenant>(`${this.baseUrl}/${id}`);
  }

  create(dto: CreateTenantDto): Observable<Tenant> {
    return this.http.post<Tenant>(this.baseUrl, dto);
  }

  update(id: string, dto: UpdateTenantDto): Observable<Tenant> {
    return this.http.patch<Tenant>(`${this.baseUrl}/${id}`, dto);
  }

  remove(id: string): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  uploadDocument(id: string, file: File, type: string): Observable<unknown> {
    const formData = new FormData();
    formData.append('document', file);
    formData.append('type', type);
    return this.http.post(`${this.baseUrl}/${id}/documents`, formData);
  }
}
