import { PrismaClient, RoleName } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { PERMISSIONS, ROLE_LABELS, ROLE_PERMISSIONS } from '../src/common/constants/permissions.constant';

const prisma = new PrismaClient();

const DEMO_ORG_CODE = 'DEMO-HORIZON';
const DEMO_ADMIN_EMAIL = 'admin@horizon-immo.demo';
const DEMO_ADMIN_PASSWORD = 'Password123!';
const DEMO_MANAGER_EMAIL = 'gestionnaire@horizon-immo.demo';
const DEMO_MANAGER_PASSWORD = 'Password123!';
const DEMO_OWNER_EMAIL = 'proprietaire@horizon-immo.demo';
const DEMO_OWNER_PASSWORD = 'Password123!';

const PLATFORM_ORG_CODE = 'PLATFORM';
const SUPER_ADMIN_EMAIL = 'superadmin@immo-platform.demo';
const SUPER_ADMIN_PASSWORD = 'Password123!';

async function seedPermissions() {
  console.log(`Seeding ${PERMISSIONS.length} permissions...`);
  for (const permission of PERMISSIONS) {
    await prisma.permission.upsert({
      where: { code: permission.code },
      update: { description: permission.description, module: permission.module },
      create: permission,
    });
  }
}

async function seedOrgRoles(organizationId: string, roleNames: RoleName[]) {
  const allPermissions = await prisma.permission.findMany();
  const permissionIdByCode = new Map(allPermissions.map((p) => [p.code, p.id]));
  const roleIds = new Map<RoleName, string>();

  for (const roleName of roleNames) {
    const role = await prisma.role.upsert({
      where: { organizationId_name: { organizationId, name: roleName } },
      update: { label: ROLE_LABELS[roleName], isSystem: true },
      create: { organizationId, name: roleName, label: ROLE_LABELS[roleName], isSystem: true },
    });
    roleIds.set(roleName, role.id);

    const codes =
      roleName === 'SUPER_ADMIN'
        ? PERMISSIONS.map((p) => p.code)
        : ROLE_PERMISSIONS[roleName as Exclude<RoleName, 'SUPER_ADMIN'>];

    await prisma.rolePermission.deleteMany({ where: { roleId: role.id } });
    const permissionIds = (codes ?? []).map((c) => permissionIdByCode.get(c)).filter((id): id is string => Boolean(id));
    if (permissionIds.length > 0) {
      await prisma.rolePermission.createMany({
        data: permissionIds.map((permissionId) => ({ roleId: role.id, permissionId })),
        skipDuplicates: true,
      });
    }
  }

  return roleIds;
}

async function main() {
  await seedPermissions();

  // ---------------------------------------------------------------------
  // Platform organization + global SUPER_ADMIN role/user.
  // The schema requires every User to carry an organizationId (spec §5), so the platform-level
  // SUPER_ADMIN account is attached to a dedicated non-tenant "platform" organization. Its Role
  // has organizationId=null (system-global role, per schema comment) and the guards
  // (RolesGuard/PermissionsGuard) special-case RoleName.SUPER_ADMIN to bypass tenant scoping
  // entirely regardless of which organization the account happens to be attached to.
  // ---------------------------------------------------------------------
  const platformOrg = await prisma.organization.upsert({
    where: { code: PLATFORM_ORG_CODE },
    update: {},
    create: { name: 'Platform', code: PLATFORM_ORG_CODE, subscriptionPlan: 'ENTERPRISE' },
  });

const allPermissions = await prisma.permission.findMany();

let superAdminRole = await prisma.role.findFirst({
  where: {
    organizationId: null,
    name: RoleName.SUPER_ADMIN,
  },
});

if (!superAdminRole) {
  superAdminRole = await prisma.role.create({
    data: {
      organizationId: null,
      name: RoleName.SUPER_ADMIN,
      label: ROLE_LABELS.SUPER_ADMIN,
      isSystem: true,
    },
  });
} else {
  superAdminRole = await prisma.role.update({
    where: {
      id: superAdminRole.id,
    },
    data: {
      label: ROLE_LABELS.SUPER_ADMIN,
      isSystem: true,
    },
  });
}
  await prisma.rolePermission.deleteMany({ where: { roleId: superAdminRole.id } });
  await prisma.rolePermission.createMany({
    data: allPermissions.map((p) => ({ roleId: superAdminRole.id, permissionId: p.id })),
    skipDuplicates: true,
  });

  const superAdminPasswordHash = await bcrypt.hash(SUPER_ADMIN_PASSWORD, 12);
  await prisma.user.upsert({
    where: { organizationId_email: { organizationId: platformOrg.id, email: SUPER_ADMIN_EMAIL } },
    update: {},
    create: {
      organizationId: platformOrg.id,
      email: SUPER_ADMIN_EMAIL,
      passwordHash: superAdminPasswordHash,
      firstName: 'Super',
      lastName: 'Admin',
      roleId: superAdminRole.id,
      isActive: true,
      isEmailVerified: true,
    },
  });

  // ---------------------------------------------------------------------
  // Demo tenant organization ("Horizon Immo") with the 4 org-scoped system roles + a demo
  // ADMIN_AGENCE user, per the task requirements.
  // ---------------------------------------------------------------------
  const demoOrg = await prisma.organization.upsert({
    where: { code: DEMO_ORG_CODE },
    update: {},
    create: {
      name: 'Horizon Immo',
      code: DEMO_ORG_CODE,
      address: 'Almadies, Dakar',
      phone: '+221 77 000 00 00',
      email: 'contact@horizon-immo.demo',
      subscriptionPlan: 'PROFESSIONAL',
    },
  });

  const demoRoleIds = await seedOrgRoles(demoOrg.id, [
    'ADMIN_AGENCE',
    'GESTIONNAIRE',
    'AGENT_IMMOBILIER',
    'LOCATAIRE',
    'PROPRIETAIRE',
  ]);
  const adminRoleId = demoRoleIds.get('ADMIN_AGENCE')!;

  const adminPasswordHash = await bcrypt.hash(DEMO_ADMIN_PASSWORD, 12);
  await prisma.user.upsert({
    where: { organizationId_email: { organizationId: demoOrg.id, email: DEMO_ADMIN_EMAIL } },
    update: {},
    create: {
      organizationId: demoOrg.id,
      email: DEMO_ADMIN_EMAIL,
      passwordHash: adminPasswordHash,
      firstName: 'Aïcha',
      lastName: 'Diop',
      roleId: adminRoleId,
      isActive: true,
      isEmailVerified: true,
    },
  });

  // ---------------------------------------------------------------------
  // V2 pivot: a demo GESTIONNAIRE + a demo PROPRIETAIRE (with an Owner record and an ACTIVE
  // ManagerOwner link between them) so the new scoped mobile flows (GET /owners,
  // GET /properties, GET /dashboard/manager, GET /dashboard/owner, ...) have something to show
  // out of the box, without over-building a full demo property/lease dataset.
  // ---------------------------------------------------------------------
  const managerRoleId = demoRoleIds.get('GESTIONNAIRE')!;
  const ownerRoleId = demoRoleIds.get('PROPRIETAIRE')!;

  const managerPasswordHash = await bcrypt.hash(DEMO_MANAGER_PASSWORD, 12);
  const demoManager = await prisma.user.upsert({
    where: { organizationId_email: { organizationId: demoOrg.id, email: DEMO_MANAGER_EMAIL } },
    update: {},
    create: {
      organizationId: demoOrg.id,
      email: DEMO_MANAGER_EMAIL,
      passwordHash: managerPasswordHash,
      firstName: 'Moussa',
      lastName: 'Fall',
      roleId: managerRoleId,
      isActive: true,
      isEmailVerified: true,
    },
  });

  const ownerPasswordHash = await bcrypt.hash(DEMO_OWNER_PASSWORD, 12);
  const demoOwnerUser = await prisma.user.upsert({
    where: { organizationId_email: { organizationId: demoOrg.id, email: DEMO_OWNER_EMAIL } },
    update: {},
    create: {
      organizationId: demoOrg.id,
      email: DEMO_OWNER_EMAIL,
      passwordHash: ownerPasswordHash,
      firstName: 'Fatou',
      lastName: 'Ndiaye',
      roleId: ownerRoleId,
      isActive: true,
      isEmailVerified: true,
    },
  });

  const demoOwner = await prisma.owner.upsert({
    where: { userId: demoOwnerUser.id },
    update: {},
    create: {
      organizationId: demoOrg.id,
      userId: demoOwnerUser.id,
      fullName: 'Fatou Ndiaye',
      phone: '+221 77 111 22 33',
      email: DEMO_OWNER_EMAIL,
    },
  });

  await prisma.managerOwner.upsert({
    where: { managerId_ownerId: { managerId: demoManager.id, ownerId: demoOwner.id } },
    update: { status: 'ACTIVE' },
    create: {
      organizationId: demoOrg.id,
      managerId: demoManager.id,
      ownerId: demoOwner.id,
      status: 'ACTIVE',
    },
  });

  console.log('\nSeed completed.');
  console.log('----------------------------------------------------');
  console.log(`SUPER_ADMIN login   : ${SUPER_ADMIN_EMAIL} / ${SUPER_ADMIN_PASSWORD}`);
  console.log(`ADMIN_AGENCE login  : ${DEMO_ADMIN_EMAIL} / ${DEMO_ADMIN_PASSWORD} (org: ${demoOrg.code})`);
  console.log(`GESTIONNAIRE login  : ${DEMO_MANAGER_EMAIL} / ${DEMO_MANAGER_PASSWORD} (org: ${demoOrg.code})`);
  console.log(
    `PROPRIETAIRE login  : ${DEMO_OWNER_EMAIL} / ${DEMO_OWNER_PASSWORD} (org: ${demoOrg.code}, managed by ${DEMO_MANAGER_EMAIL})`,
  );
  console.log('----------------------------------------------------');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
