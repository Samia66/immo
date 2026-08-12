import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Observable } from 'rxjs';
import { RoleName } from '@prisma/client';
import { TenantContextService } from '../../prisma/tenant-context.service';
import { AuthenticatedUser } from '../interfaces/authenticated-user.interface';

/**
 * Runs the rest of the request pipeline inside an AsyncLocalStorage context carrying the
 * caller's organizationId (extracted from the JWT-authenticated user). PrismaService's
 * middleware reads this context to auto-scope every tenant query.
 *
 * Runs AFTER guards (so `req.user` is already populated) and BEFORE the controller handler,
 * matching Nest's execution order: middleware -> guards -> interceptors -> pipes -> handler.
 */
@Injectable()
export class TenantInterceptor implements NestInterceptor {
  constructor(private readonly tenantContext: TenantContextService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const request = context.switchToHttp().getRequest();
    const user: AuthenticatedUser | undefined = request.user;

    const store = {
      organizationId: user?.organizationId ?? null,
      isSuperAdmin: user?.roleName === RoleName.SUPER_ADMIN,
      userId: user?.id,
    };

    return this.tenantContext.run(store, () => next.handle());
  }
}
