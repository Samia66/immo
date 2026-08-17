import { Injectable, Logger, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { Prisma, PrismaClient } from '@prisma/client';
import { TenantContextService } from './tenant-context.service';

/**
 * Prisma models that carry an `organizationId` column and therefore must be automatically
 * scoped to the current tenant. Kept as a literal list (rather than introspected) so the
 * middleware behaviour is explicit and easy to audit.
 */
const TENANT_SCOPED_MODELS = new Set<string>([
  'User',
  'Role',
  'Property',
  'PropertyUnit',
  'Owner',
  'Tenant',
  'Lease',
  'Payment',
  'Expense',
  'MaintenanceRequest',
  'Notification',
  'AuditLog',
  'TenantInvitation',
  'OwnerInvitation',
  'ManagerOwner',
  'PropertyManagement',
  'Receipt',
]);

/**
 * Prisma rejects a `data` object that sets both the scalar FK (`organizationId`) and the
 * nested relation (`organization: { connect: {...} }`) for the same relation — most services
 * write the relation form explicitly, so the middleware must not also inject the scalar form
 * on top of it (that was throwing PrismaClientValidationError on every tenant-scoped create).
 */
function hasOrganizationLink(data: unknown): boolean {
  return typeof data === 'object' && data !== null && ('organizationId' in data || 'organization' in data);
}

const WRITE_ACTIONS_WITH_DATA = new Set(['create', 'createMany']);
const ACTIONS_WITH_WHERE = new Set([
  'findFirst',
  'findFirstOrThrow',
  'findMany',
  'findUnique',
  'findUniqueOrThrow',
  'update',
  'updateMany',
  'delete',
  'deleteMany',
  'count',
  'aggregate',
  'groupBy',
]);

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(PrismaService.name);

  constructor(private readonly tenantContext: TenantContextService) {
    super({
      log: process.env.NODE_ENV === 'development' ? ['warn', 'error'] : ['error'],
    });
    this.registerTenantMiddleware();
  }

  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }

  /**
   * Injects `organizationId` automatically on every query/mutation against a tenant-scoped
   * model, based on the AsyncLocalStorage tenant context set by TenantInterceptor.
   * - No context (e.g. seed scripts, cron jobs run outside a request) => middleware is a no-op,
   *   the caller is responsible for filtering explicitly.
   * - SUPER_ADMIN context => middleware is a no-op, admin operates across all organizations.
   */
  private registerTenantMiddleware() {
    this.$use(async (params: Prisma.MiddlewareParams, next: (params: Prisma.MiddlewareParams) => Promise<unknown>) => {
      if (!params.model || !TENANT_SCOPED_MODELS.has(params.model)) {
        return next(params);
      }

      const store = this.tenantContext.getStore();
      if (!store || store.isSuperAdmin || !store.organizationId) {
        return next(params);
      }

      const organizationId = store.organizationId;
      params.args = params.args ?? {};

      if (WRITE_ACTIONS_WITH_DATA.has(params.action)) {
        if (params.action === 'createMany' && Array.isArray(params.args.data)) {
          params.args.data = params.args.data.map((item: Record<string, unknown>) =>
            hasOrganizationLink(item) ? item : { ...item, organizationId },
          );
        } else if (params.args.data && !hasOrganizationLink(params.args.data)) {
          params.args.data = { ...params.args.data, organizationId };
        }
      } else if (params.action === 'upsert') {
        params.args.where = { ...(params.args.where ?? {}), organizationId };
        if (params.args.create && !hasOrganizationLink(params.args.create)) {
          params.args.create = { ...params.args.create, organizationId };
        }
        if (params.args.update && 'organizationId' in params.args.update) {
          delete params.args.update.organizationId;
        }
      } else if (ACTIONS_WITH_WHERE.has(params.action)) {
        params.args.where = { ...(params.args.where ?? {}), organizationId };
        if (params.args.data && 'organizationId' in params.args.data) {
          delete params.args.data.organizationId;
        }
      }

      return next(params);
    });
  }
}
