import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { BehaviorSubject, catchError, filter, switchMap, take, throwError } from 'rxjs';
import { AuthService } from '../services/auth.service';

let isRefreshing = false;
const refreshedToken$ = new BehaviorSubject<string | null>(null);

/**
 * Catches 401 responses, attempts a single silent `/auth/refresh` (HttpOnly cookie),
 * then replays the original request. If the refresh itself fails, the user is logged out
 * and redirected to the login page.
 */
export const refreshInterceptor: HttpInterceptorFn = (req, next) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  const isAuthRoute = /\/auth\/(login|register|refresh|logout)$/.test(req.url);

  return next(req).pipe(
    catchError((error: unknown) => {
      if (!(error instanceof HttpErrorResponse) || error.status !== 401 || isAuthRoute) {
        return throwError(() => error);
      }

      if (!isRefreshing) {
        isRefreshing = true;
        refreshedToken$.next(null);

        return authService.refresh().pipe(
          switchMap((res) => {
            isRefreshing = false;
            refreshedToken$.next(res.accessToken);
            return next(req.clone({ setHeaders: { Authorization: `Bearer ${res.accessToken}` } }));
          }),
          catchError((refreshError) => {
            isRefreshing = false;
            authService.clearSession();
            router.navigate(['/auth/login'], { queryParams: { returnUrl: router.url } });
            return throwError(() => refreshError);
          }),
        );
      }

      // A refresh is already in flight: wait for it, then replay this request too.
      return refreshedToken$.pipe(
        filter((token): token is string => token !== null),
        take(1),
        switchMap((token) => next(req.clone({ setHeaders: { Authorization: `Bearer ${token}` } }))),
      );
    }),
  );
};
