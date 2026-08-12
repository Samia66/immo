import { createParamDecorator, ExecutionContext } from '@nestjs/common';

/** Extracts the current user's organizationId from the request. */
export const TenantId = createParamDecorator((_data: unknown, ctx: ExecutionContext): string => {
  const request = ctx.switchToHttp().getRequest();
  return request.user?.organizationId;
});
