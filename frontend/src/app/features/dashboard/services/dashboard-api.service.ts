import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { AdminDashboard, ManagerDashboard, TenantDashboard } from '../models/dashboard.model';

@Injectable({ providedIn: 'root' })
export class DashboardApiService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/dashboard`;

  getAdmin(): Observable<AdminDashboard> {
    return this.http.get<AdminDashboard>(`${this.baseUrl}/admin`);
  }

  getManager(): Observable<ManagerDashboard> {
    return this.http.get<ManagerDashboard>(`${this.baseUrl}/manager`);
  }

  getTenant(): Observable<TenantDashboard> {
    return this.http.get<TenantDashboard>(`${this.baseUrl}/tenant`);
  }
}
