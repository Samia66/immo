import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { PaginatedResult } from '../../../core/models';
import {
  CreatePropertyDto,
  Property,
  PropertyHistoryEntry,
  PropertyImage,
  PropertyQuery,
  UpdatePropertyDto,
} from '../models/property.model';

@Injectable({ providedIn: 'root' })
export class PropertiesApiService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/properties`;

  list(query: PropertyQuery): Observable<PaginatedResult<Property>> {
    return this.http.get<PaginatedResult<Property>>(this.baseUrl, {
      params: this.toHttpParams(query as unknown as Record<string, unknown>),
    });
  }

  getById(id: string): Observable<Property> {
    return this.http.get<Property>(`${this.baseUrl}/${id}`);
  }

  create(dto: CreatePropertyDto): Observable<Property> {
    return this.http.post<Property>(this.baseUrl, dto);
  }

  update(id: string, dto: UpdatePropertyDto): Observable<Property> {
    return this.http.patch<Property>(`${this.baseUrl}/${id}`, dto);
  }

  remove(id: string): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  uploadImages(id: string, files: File[]): Observable<PropertyImage[]> {
    const formData = new FormData();
    files.forEach((file) => formData.append('images', file));
    return this.http.post<PropertyImage[]>(`${this.baseUrl}/${id}/images`, formData);
  }

  deleteImage(id: string, imageId: string): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}/images/${imageId}`);
  }

  history(id: string): Observable<PropertyHistoryEntry[]> {
    return this.http.get<PropertyHistoryEntry[]>(`${this.baseUrl}/${id}/history`);
  }

  nearby(lat: number, lng: number, radius: number): Observable<Property[]> {
    return this.http.get<Property[]>(`${this.baseUrl}/nearby`, {
      params: { lat, lng, radius } as unknown as Record<string, string>,
    });
  }

  private toHttpParams(query: Record<string, unknown>): HttpParams {
    let params = new HttpParams();
    for (const [key, value] of Object.entries(query)) {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    }
    return params;
  }
}
