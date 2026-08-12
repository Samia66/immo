import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { AuthenticatedUser } from '../interfaces/authenticated-user.interface';

/**
 * Extracts the authenticated user (attached to the request by JwtAuthGuard / JwtStrategy).
 * Usage: `@CurrentUser() user: AuthenticatedUser` or `@CurrentUser('id') userId: string`.
 */
export const CurrentUser = createParamDecorator((data: keyof AuthenticatedUser | undefined, ctx: ExecutionContext) => {
  const request = ctx.switchToHttp().getRequest();
  const user: AuthenticatedUser | undefined = request.user;
  if (!user) return undefined;
  return data ? user[data] : user;
});
