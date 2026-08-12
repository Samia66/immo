import { CanActivate, ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { RoleName } from '@prisma/client';
import { PERMISSIONS_KEY } from '../decorators/permissions.decorator';
import { AuthenticatedUser } from '../interfaces/authenticated-user.interface';

/**
 * Reads permission codes off route metadata (@Permissions(...)) and checks them against the
 * effective permissions of the current user's role (RolePermission). Access is granted if the
 * user's permission set contains AT LEAST ONE of the required codes. SUPER_ADMIN always passes.
 */
@Injectable()
export class PermissionsGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredPermissions = this.reflector.getAllAndOverride<string[]>(PERMISSIONS_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredPermissions || requiredPermissions.length === 0) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const user: AuthenticatedUser | undefined = request.user;

    if (!user) {
      throw new ForbiddenException('Utilisateur non authentifié.');
    }

    if (user.roleName === RoleName.SUPER_ADMIN) {
      return true;
    }

    const hasPermission = requiredPermissions.some((code) => user.permissions.includes(code));

    if (!hasPermission) {
      throw new ForbiddenException(`Permission refusée. Requis: ${requiredPermissions.join(' ou ')}.`);
    }

    return true;
  }
}
