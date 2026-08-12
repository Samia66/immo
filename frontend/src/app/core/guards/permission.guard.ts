import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

/** Restricts a route to users whose effective role carries the given permission code. */
export const permissionGuard = (code: string): CanActivateFn => {
  return () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    if (authService.hasPermission(code)) {
      return true;
    }

    return router.createUrlTree(['/app/dashboard']);
  };
};
