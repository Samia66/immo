import { HttpClient } from '@angular/common/http';
import { Injectable, computed, inject, signal } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { tap } from 'rxjs';
import { environment } from '../../../environments/environment';
import { AppNotification, PaginatedResult } from '../models';

/**
 * Handles both in-app notification data (list, unread count, mark-as-read)
 * and ephemeral snackbar toasts used across the whole app (success/error).
 */
@Injectable({ providedIn: 'root' })
export class NotificationService {
  private readonly http = inject(HttpClient);
  private readonly snackBar = inject(MatSnackBar);
  private readonly baseUrl = `${environment.apiUrl}/notifications`;

  private readonly _notifications = signal<AppNotification[]>([]);
  private readonly _unreadCount = signal(0);

  readonly notifications = this._notifications.asReadonly();
  readonly unreadCount = this._unreadCount.asReadonly();
  readonly hasUnread = computed(() => this._unreadCount() > 0);

  list(page = 1, limit = 20) {
    return this.http
      .get<PaginatedResult<AppNotification>>(this.baseUrl, { params: { page, limit } as any })
      .pipe(tap((res) => this._notifications.set(res.data)));
  }

  refreshUnreadCount() {
    return this.http
      .get<{ count: number }>(`${this.baseUrl}/unread-count`)
      .pipe(tap((res) => this._unreadCount.set(res.count)));
  }

  markAsRead(id: string) {
    return this.http.patch(`${this.baseUrl}/${id}/read`, {}).pipe(
      tap(() => {
        this._notifications.update((list) =>
          list.map((n) => (n.id === id ? { ...n, isRead: true } : n)),
        );
        this._unreadCount.update((count) => Math.max(0, count - 1));
      }),
    );
  }

  markAllAsRead() {
    return this.http.patch(`${this.baseUrl}/read-all`, {}).pipe(
      tap(() => {
        this._notifications.update((list) => list.map((n) => ({ ...n, isRead: true })));
        this._unreadCount.set(0);
      }),
    );
  }

  success(message: string): void {
    this.snackBar.open(message, 'Fermer', { duration: 4000, panelClass: 'snackbar-success' });
  }

  error(message: string): void {
    this.snackBar.open(message, 'Fermer', { duration: 6000, panelClass: 'snackbar-error' });
  }

  info(message: string): void {
    this.snackBar.open(message, 'Fermer', { duration: 4000, panelClass: 'snackbar-info' });
  }
}
