import { RoleName } from '@prisma/client';

/**
 * Shape of the user object attached to `req.user` by the JWT strategy,
 * and made available via the @CurrentUser() decorator.
 */
export interface AuthenticatedUser {
  id: string;
  organizationId: string;
  email: string;
  firstName: string;
  lastName: string;
  roleId: string;
  roleName: RoleName;
  /** Flattened list of permission codes effective for this user's role (e.g. "properties:read"). */
  permissions: string[];
  tenantProfileId?: string | null;
}
