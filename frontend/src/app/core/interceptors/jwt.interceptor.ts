import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { TokenStorageService } from '../services/token-storage.service';

/** Attaches the Bearer access token to every outgoing request (except public auth routes). */
export const jwtInterceptor: HttpInterceptorFn = (req, next) => {
  const tokenStorage = inject(TokenStorageService);
  const token = tokenStorage.getAccessToken();

  const isPublicAuthRoute =
    /\/auth\/(login|register|refresh|forgot-password|reset-password|verify-email)$/.test(req.url);

  if (!token || isPublicAuthRoute) {
    return next(req);
  }

  return next(
    req.clone({
      setHeaders: { Authorization: `Bearer ${token}` },
    }),
  );
};
