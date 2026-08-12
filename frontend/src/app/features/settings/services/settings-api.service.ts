import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { Organization, PaginatedResult } from '../../../core/models';
import { Permission, Role, User } from '../../../core/models/user.model';
import { CreateUserDto, UpdateUserDto, UserQuery } from '../models/settings.model';

@Injectable({ providedIn: 'root' })
export class SettingsApiService {
  private readonly http = inject(HttpClient);
  private readonly apiUrl = environment.apiUrl;

  // Organization (current tenant)
  getMyOrganization(): Observable<Organization> {
    return this.http.get<Organization>(`${this.apiUrl}/organizations/me`);
  }

  updateMyOrganization(dto: Partial<Organization>): Observable<Organization> {
    return this.http.patch<Organization>(`${this.apiUrl}/organizations/me`, dto);
  }

  // Users
  listUsers(query: UserQuery = {}): Observable<PaginatedResult<User>> {
    let params = new HttpParams();
    for (const [key, value] of Object.entries(query)) {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    }
    return this.http.get<PaginatedResult<User>>(`${this.apiUrl}/users`, { params });
  }

  createUser(dto: CreateUserDto): Observable<User> {
    return this.http.post<User>(`${this.apiUrl}/users`, dto);
  }

  updateUser(id: string, dto: UpdateUserDto): Observable<User> {
    return this.http.patch<User>(`${this.apiUrl}/users/${id}`, dto);
  }

  changeUserRole(id: string, roleId: string): Observable<User> {
    return this.http.patch<User>(`${this.apiUrl}/users/${id}/role`, { roleId });
  }

  toggleUserActive(id: string): Observable<User> {
    return this.http.patch<User>(`${this.apiUrl}/users/${id}/toggle-active`, {});
  }

  removeUser(id: string): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/users/${id}`);
  }

  // Roles & permissions
  listRoles(): Observable<Role[]> {
    return this.http.get<Role[]>(`${this.apiUrl}/roles`);
  }

  listPermissions(): Observable<Permission[]> {
    return this.http.get<Permission[]>(`${this.apiUrl}/permissions`);
  }

  updateRolePermissions(roleId: string, permissionIds: string[]): Observable<Role> {
    return this.http.patch<Role>(`${this.apiUrl}/roles/${roleId}/permissions`, { permissionIds });
  }
}
