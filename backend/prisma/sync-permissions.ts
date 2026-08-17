import { PrismaClient, RoleName } from '@prisma/client';
import { PERMISSIONS, ROLE_PERMISSIONS } from '../src/common/constants/permissions.constant';

const prisma = new PrismaClient();

/**
 * Backfills every existing Role's permissions against the current
 * ROLE_PERMISSIONS constant, across every organization.
 *
 * A Role's RolePermission rows are only ever written once, at Organization
 * creation time (AuthService.register(), or seed.ts for the fixed demo org).
 * An organization created before a permission was added to ROLE_PERMISSIONS
 * never picks it up on its own - that's what caused both the
 * maintenance:manage_attachments and payments:read 403s seen in testing.
 * Additive only (skipDuplicates, no delete first) so it never removes a
 * permission grant customized by hand via PATCH /roles/:id/permissions -
 * just fills in whatever the constant says a role should have but the DB
 * doesn't yet. Safe to re-run any time.
 */
async function main() {
  for (const permission of PERMISSIONS) {
    await prisma.permission.upsert({
      where: { code: permission.code },
      update: { description: permission.description, module: permission.module },
      create: permission,
    });
  }

  const allPermissions = await prisma.permission.findMany();
  const permissionIdByCode = new Map(allPermissions.map((p) => [p.code, p.id]));

  const roles = await prisma.role.findMany();
  let rolesTouched = 0;
  let rowsAdded = 0;

  for (const role of roles) {
    const codes =
      role.name === RoleName.SUPER_ADMIN
        ? PERMISSIONS.map((p) => p.code)
        : ROLE_PERMISSIONS[role.name as Exclude<RoleName, 'SUPER_ADMIN'>];

    const permissionIds = (codes ?? [])
      .map((c) => permissionIdByCode.get(c))
      .filter((id): id is string => Boolean(id));

    if (permissionIds.length === 0) continue;

    const result = await prisma.rolePermission.createMany({
      data: permissionIds.map((permissionId) => ({ roleId: role.id, permissionId })),
      skipDuplicates: true,
    });

    if (result.count > 0) {
      rolesTouched += 1;
      rowsAdded += result.count;
    }
  }

  console.log(`Synced ${roles.length} role(s): added ${rowsAdded} missing permission(s) across ${rolesTouched} role(s).`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
