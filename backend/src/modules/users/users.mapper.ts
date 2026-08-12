import { User, Role } from '@prisma/client';

type UserWithRole = User & { role: Role };

export class UsersMapper {
  static toResponse(user: UserWithRole) {
    return {
      id: user.id,
      organizationId: user.organizationId,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      avatarUrl: user.avatarUrl,
      role: { id: user.role.id, name: user.role.name, label: user.role.label },
      isActive: user.isActive,
      isEmailVerified: user.isEmailVerified,
      lastLoginAt: user.lastLoginAt,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    };
  }
}
