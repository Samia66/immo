import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { PaginatedResult } from '../../../core/models';
import { CreateOwnerDto, Owner, OwnerQuery, UpdateOwnerDto } from '../models/owner.model';

@Injectable({ providedIn: 'root' })
export class OwnersApiService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/owners`;

  list(query: OwnerQuery = {}): Observable<PaginatedResult<Owner>> {
    let params = new HttpParams();
    for (const [key, value] of Object.entries(query)) {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    }
    return this.http.get<PaginatedResult<Owner>>(this.baseUrl, { params });
  }

  getById(id: string): Observable<Owner> {
    return this.http.get<Owner>(`${this.baseUrl}/${id}`);
  }

  create(dto: CreateOwnerDto): Observable<Owner> {
    return this.http.post<Owner>(this.baseUrl, dto);
  }

  update(id: string, dto: UpdateOwnerDto): Observable<Owner> {
    return this.http.patch<Owner>(`${this.baseUrl}/${id}`, dto);
  }

  remove(id: string): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
