import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { PaginatedResult } from '../../../core/models';
import {
  AssignMaintenanceDto,
  CreateMaintenanceRequestDto,
  MaintenanceQuery,
  MaintenanceRequest,
  UpdateMaintenanceStatusDto,
} from '../models/maintenance.model';

@Injectable({ providedIn: 'root' })
export class MaintenanceApiService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/maintenance`;

  list(query: MaintenanceQuery = {}): Observable<PaginatedResult<MaintenanceRequest>> {
    let params = new HttpParams();
    for (const [key, value] of Object.entries(query)) {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    }
    return this.http.get<PaginatedResult<MaintenanceRequest>>(this.baseUrl, { params });
  }

  getById(id: string): Observable<MaintenanceRequest> {
    return this.http.get<MaintenanceRequest>(`${this.baseUrl}/${id}`);
  }

  create(dto: CreateMaintenanceRequestDto): Observable<MaintenanceRequest> {
    return this.http.post<MaintenanceRequest>(this.baseUrl, dto);
  }

  validate(id: string): Observable<MaintenanceRequest> {
    return this.http.patch<MaintenanceRequest>(`${this.baseUrl}/${id}/validate`, {});
  }

  assign(id: string, dto: AssignMaintenanceDto): Observable<MaintenanceRequest> {
    return this.http.patch<MaintenanceRequest>(`${this.baseUrl}/${id}/assign`, dto);
  }

  updateStatus(id: string, dto: UpdateMaintenanceStatusDto): Observable<MaintenanceRequest> {
    return this.http.patch<MaintenanceRequest>(`${this.baseUrl}/${id}/status`, dto);
  }

  uploadAttachments(id: string, files: File[], phase: 'AVANT' | 'APRES'): Observable<unknown> {
    const formData = new FormData();
    files.forEach((file) => formData.append('attachments', file));
    formData.append('phase', phase);
    return this.http.post(`${this.baseUrl}/${id}/attachments`, formData);
  }

  me(): Observable<PaginatedResult<MaintenanceRequest>> {
    return this.http.get<PaginatedResult<MaintenanceRequest>>(`${this.baseUrl}/me`);
  }
}
