import { PrismaService } from '../../prisma/prisma.service';

/**
 * Shared sub-queries for the GESTIONNAIRE data-visibility scoping (V2 pivot): a manager only
 * sees the owners/properties explicitly linked to them via an ACTIVE `ManagerOwner`/
 * `PropertyManagement` row. Factored out once here and reused by owners/properties/tenants/
 * leases/maintenance/dashboard services instead of duplicating the same sub-query five times.
 *
 * Both run inside the caller's existing tenant context (organizationId is already applied by
 * PrismaService's tenant middleware to ManagerOwner/PropertyManagement, both TENANT_SCOPED_MODELS),
 * so callers do not need to pass organizationId explicitly.
 */

/** Owner ids ACTIVE-linked to this manager. */
export async function getManagedOwnerIds(prisma: PrismaService, managerId: string): Promise<string[]> {
  const rows = await prisma.managerOwner.findMany({
    where: { managerId, status: 'ACTIVE' },
    select: { ownerId: true },
  });
  return rows.map((r) => r.ownerId);
}

/** Property ids ACTIVE-linked to this manager. */
export async function getManagedPropertyIds(prisma: PrismaService, managerId: string): Promise<string[]> {
  const rows = await prisma.propertyManagement.findMany({
    where: { managerId, status: 'ACTIVE' },
    select: { propertyId: true },
  });
  return rows.map((r) => r.propertyId);
}
