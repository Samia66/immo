import { RoleName } from './enums';

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

export interface CurrentUser extends User {
  permissions: string[];
}
