import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

const includePermissions = { permissions: { include: { permission: true } } } as const;

@Injectable()
export class RolesRepository {
  constructor(private readonly prisma: PrismaService) {}

  findAllForOrg(organizationId: string) {
    return this.prisma.role.findMany({
      where: { organizationId },
      include: includePermissions,
      orderBy: { name: 'asc' },
    });
  }

  findById(id: string) {
    return this.prisma.role.findUnique({ where: { id }, include: includePermissions });
  }

  findByOrgAndName(organizationId: string, name: string) {
    return this.prisma.role.findFirst({ where: { organizationId, name: name as any }, include: includePermissions });
  }

  create(organizationId: string, name: string, label: string) {
    return this.prisma.role.create({
      data: { organizationId, name: name as any, label, isSystem: false },
      include: includePermissions,
    });
  }

  async replacePermissions(roleId: string, permissionIds: string[]) {
    await this.prisma.rolePermission.deleteMany({ where: { roleId } });
    if (permissionIds.length > 0) {
      await this.prisma.rolePermission.createMany({
        data: permissionIds.map((permissionId) => ({ roleId, permissionId })),
        skipDuplicates: true,
      });
    }
    return this.findById(roleId);
  }
}
