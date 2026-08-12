import { SetMetadata } from '@nestjs/common';

export const PERMISSIONS_KEY = 'permissions';

/**
 * Restricts a route to callers whose effective role permissions contain AT LEAST ONE of the
 * given permission codes (e.g. "properties:create"). SUPER_ADMIN always passes (see PermissionsGuard).
 */
export const Permissions = (...codes: string[]) => SetMetadata(PERMISSIONS_KEY, codes);
