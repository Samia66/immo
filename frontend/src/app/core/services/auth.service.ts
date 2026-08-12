import { HttpClient } from '@angular/common/http';
import { Injectable, computed, inject, signal } from '@angular/core';
import { Observable, catchError, of, tap } from 'rxjs';
import { environment } from '../../../environments/environment';
import { CurrentUser, RoleName } from '../models';
import { TokenStorageService } from './token-storage.service';

export interface LoginPayload {
  email: string;
  password: string;
}

export interface RegisterPayload {
  organizationName: string;
  email: string;
  password: string;
  firstName: string;
  lastName: string;
}

export interface AuthResponse {
  accessToken: string;
  user: CurrentUser;
}

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly http = inject(HttpClient);
  private readonly tokenStorage = inject(TokenStorageService);
  private readonly baseUrl = `${environment.apiUrl}/auth`;

  private readonly _currentUser = signal<CurrentUser | null>(null);
  private readonly _initialized = signal(false);

  readonly currentUser = this._currentUser.asReadonly();
  readonly initialized = this._initialized.asReadonly();
  readonly isAuthenticated = computed(() => this._currentUser() !== null);
  readonly role = computed<RoleName | null>(() => this._currentUser()?.roleName ?? null);
  readonly permissions = computed<string[]>(() => this._currentUser()?.permissions ?? []);

  login(payload: LoginPayload): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.baseUrl}/login`, payload, { withCredentials: true }).pipe(
      tap((res) => this.setSession(res)),
    );
  }

  register(payload: RegisterPayload): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.baseUrl}/register`, payload, { withCredentials: true }).pipe(
      tap((res) => this.setSession(res)),
    );
  }

  refresh(): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.baseUrl}/refresh`, {}, { withCredentials: true }).pipe(
      tap((res) => this.setSession(res)),
    );
  }

  logout(): Observable<unknown> {
    return this.http.post(`${this.baseUrl}/logout`, {}, { withCredentials: true }).pipe(
      tap(() => this.clearSession()),
      catchError(() => {
        this.clearSession();
        return of(null);
      }),
    );
  }

  forgotPassword(email: string): Observable<unknown> {
    return this.http.post(`${this.baseUrl}/forgot-password`, { email });
  }

  resetPassword(token: string, newPassword: string): Observable<unknown> {
    return this.http.post(`${this.baseUrl}/reset-password`, { token, newPassword });
  }

  changePassword(currentPassword: string, newPassword: string): Observable<unknown> {
    return this.http.post(`${this.baseUrl}/change-password`, { currentPassword, newPassword });
  }

  verifyEmail(token: string): Observable<unknown> {
    return this.http.post(`${this.baseUrl}/verify-email`, { token });
  }

  /** Attempts a silent session restore (existing access token or refresh cookie) on app bootstrap. */
  bootstrap(): Observable<CurrentUser | null> {
    if (!this.tokenStorage.getAccessToken()) {
      this._initialized.set(true);
      return of(null);
    }
    return this.http.get<CurrentUser>(`${this.baseUrl}/me`).pipe(
      tap((user) => {
        this._currentUser.set(user);
        this._initialized.set(true);
      }),
      catchError(() => {
        this.clearSession();
        this._initialized.set(true);
        return of(null);
      }),
    );
  }

  hasPermission(code: string): boolean {
    return this.permissions().includes(code);
  }

  hasRole(...roles: RoleName[]): boolean {
    const current = this.role();
    return current !== null && roles.includes(current);
  }

  setSession(res: AuthResponse): void {
    this.tokenStorage.setAccessToken(res.accessToken);
    this._currentUser.set(res.user);
    this._initialized.set(true);
  }

  clearSession(): void {
    this.tokenStorage.clear();
    this._currentUser.set(null);
  }
}
