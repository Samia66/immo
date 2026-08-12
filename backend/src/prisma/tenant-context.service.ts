import { Injectable } from '@nestjs/common';
import { AsyncLocalStorage } from 'async_hooks';

export interface TenantStore {
  organizationId: string | null;
  isSuperAdmin: boolean;
  userId?: string;
}

/**
 * Request-scoped tenant context backed by Node's AsyncLocalStorage, populated by
 * TenantInterceptor from the authenticated user's JWT claims and read by PrismaService's
 * `$use` middleware to auto-scope every tenant query by organizationId.
 *
 * SUPER_ADMIN requests set `isSuperAdmin: true`, which makes PrismaService skip automatic
 * organizationId injection entirely (the admin operates across all organizations).
 */
@Injectable()
export class TenantContextService {
  private readonly als = new AsyncLocalStorage<TenantStore>();

  run<T>(store: TenantStore, callback: () => T): T {
    return this.als.run(store, callback);
  }

  getStore(): TenantStore | undefined {
    return this.als.getStore();
  }

  getOrganizationId(): string | null {
    return this.getStore()?.organizationId ?? null;
  }

  isSuperAdmin(): boolean {
    return this.getStore()?.isSuperAdmin ?? false;
  }
}
