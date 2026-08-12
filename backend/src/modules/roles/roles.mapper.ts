import { Role, RolePermission, Permission } from '@prisma/client';

type RoleWithPermissions = Role & { permissions: (RolePermission & { permission: Permission })[] };

export class RolesMapper {
  static toResponse(role: RoleWithPermissions) {
    return {
      id: role.id,
      organizationId: role.organizationId,
      name: role.name,
      label: role.label,
      isSystem: role.isSystem,
      permissions: role.permissions.map((rp) => ({ code: rp.permission.code, module: rp.permission.module })),
      createdAt: role.createdAt,
      updatedAt: role.updatedAt,
    };
  }
}
