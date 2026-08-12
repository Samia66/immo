git diff --statimport { RoleName } from './enums';

export interface Role {
  id: string;
  organizationId: string | null;
  name: RoleName;
  label: string;
  isSystem: boolean;
  permissions?: Permission[];
}

export interface Permission {
  id: string;
  code: string;
  description?: string | null;
  module: string;
}

export interface User {
  id: string;
  organizationId: string;
  email: string;
  firstName: string;
  lastName: string;
  phone?: string | null;
  avatarUrl?: string | null;
  role: Role;
  isActive: boolean;
  isEmailVerified: boolean;
  lastLoginAt?: string | null;
  createdAt: string;
  updatedAt: string;
}

/**
 * Shape returned by /auth/login, /auth/refresh, /auth/me (AuthUserDto on the backend) —
 * flatter than the full `User` entity returned by /users: role is a bare `roleName` string,
 * not a nested `Role` object, and fields like `phone`/`avatarUrl`/`lastLoginAt` aren't included.
 */
export interface CurrentUser {
  id: string;
  organizationId: string;
  email: string;
  firstName: string;
  lastName: string;
  roleName: RoleName;
  permissions: string[];
  isEmailVerified: boolean;
}
