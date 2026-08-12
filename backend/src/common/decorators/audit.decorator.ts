import { SetMetadata } from '@nestjs/common';
import { AuditAction } from '@prisma/client';

export const AUDIT_KEY = 'audit';

export interface AuditMetadata {
  action: AuditAction;
  entity: string;
}

/**
 * Marks a route handler as a sensitive action to be journaled into AuditLog by AuditInterceptor.
 * `entity` is a static label (e.g. "Payment"); the entity id is inferred from the response body's
 * `id` field (or route param `id`) when available.
 */
export const Audit = (action: AuditAction, entity: string) =>
  SetMetadata(AUDIT_KEY, { action, entity } as AuditMetadata);
