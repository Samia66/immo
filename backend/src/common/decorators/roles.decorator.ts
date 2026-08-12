import { SetMetadata } from '@nestjs/common';
import { RoleName } from '@prisma/client';

export const ROLES_KEY = 'roles';

/** Restricts a route to one or more RoleName values. SUPER_ADMIN always passes (see RolesGuard). */
export const Roles = (...roles: RoleName[]) => SetMetadata(ROLES_KEY, roles);
