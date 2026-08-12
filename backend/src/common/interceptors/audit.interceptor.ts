import { CallHandler, ExecutionContext, Injectable, Logger, NestInterceptor } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { PrismaService } from '../../prisma/prisma.service';
import { AUDIT_KEY, AuditMetadata } from '../decorators/audit.decorator';
import { AuthenticatedUser } from '../interfaces/authenticated-user.interface';

/**
 * Journals sensitive actions (payment recorded, lease terminated, role changed, etc.) into
 * AuditLog, based on routes marked with @Audit(action, entity). Fire-and-forget: a logging
 * failure never breaks the actual business response.
 */
@Injectable()
export class AuditInterceptor implements NestInterceptor {
  private readonly logger = new Logger('AuditInterceptor');

  constructor(
    private readonly reflector: Reflector,
    private readonly prisma: PrismaService,
  ) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const meta = this.reflector.getAllAndOverride<AuditMetadata | undefined>(AUDIT_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!meta) {
      return next.handle();
    }

    const request = context.switchToHttp().getRequest();
    const user: AuthenticatedUser | undefined = request.user;

    return next.handle().pipe(
      tap((responseBody) => {
        const entityId =
          (responseBody && typeof responseBody === 'object' && (responseBody as any).id) || request.params?.id || null;

        this.prisma.auditLog
          .create({
            data: {
              action: meta.action,
              entity: meta.entity,
              entityId,
              userId: user?.id,
              ipAddress: request.ip,
              metadata: { method: request.method, path: request.originalUrl ?? request.url },
            },
          })
          .catch((err) => this.logger.error(`Failed to write audit log: ${err?.message}`));
      }),
    );
  }
}
