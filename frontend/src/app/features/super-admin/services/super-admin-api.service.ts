import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { Organization, PaginatedResult } from '../../../core/models';
import { SubscriptionPlan } from '../../../core/models/enums';
import { CreateOrganizationDto, OrganizationQuery, SuperAdminStatistics } from '../models/super-admin.model';

@Injectable({ providedIn: 'root' })
export class SuperAdminApiService {
  private readonly http = inject(HttpClient);
  private readonly apiUrl = environment.apiUrl;

  listOrganizations(query: OrganizationQuery = {}): Observable<PaginatedResult<Organization>> {
    let params = new HttpParams();
    for (const [key, value] of Object.entries(query)) {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    }
    return this.http.get<PaginatedResult<Organization>>(`${this.apiUrl}/organizations`, { params });
  }

  getOrganization(id: string): Observable<Organization> {
    return this.http.get<Organization>(`${this.apiUrl}/organizations/${id}`);
  }

  createOrganization(dto: CreateOrganizationDto): Observable<Organization> {
    return this.http.post<Organization>(`${this.apiUrl}/organizations`, dto);
  }

  updateOrganization(id: string, dto: Partial<CreateOrganizationDto>): Observable<Organization> {
    return this.http.patch<Organization>(`${this.apiUrl}/organizations/${id}`, dto);
  }

  updateSubscription(id: string, subscriptionPlan: SubscriptionPlan): Observable<Organization> {
    return this.http.patch<Organization>(`${this.apiUrl}/organizations/${id}/subscription`, { subscriptionPlan });
  }

  toggleActive(id: string): Observable<Organization> {
    return this.http.patch<Organization>(`${this.apiUrl}/organizations/${id}/toggle-active`, {});
  }

  getStatistics(): Observable<SuperAdminStatistics> {
    return this.http.get<SuperAdminStatistics>(`${this.apiUrl}/dashboard/super-admin`);
  }
}
