import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { RoleName } from '../models';

/** Restricts a route to one or more roles, e.g. `roleGuard([RoleName.ADMIN_AGENCE])`. */
export const roleGuard = (roles: RoleName[]): CanActivateFn => {
  return () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    if (authService.hasRole(...roles)) {
      return true;
    }

    return router.createUrlTree(['/app/dashboard']);
  };
};
