import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { RolesRepository } from './roles.repository';
import { RolesMapper } from './roles.mapper';
import { CreateRoleDto, UpdateRolePermissionsDto } from './dto';

@Injectable()
export class RolesService {
  constructor(
    private readonly repo: RolesRepository,
    private readonly prisma: PrismaService,
  ) {}

  async findAll(organizationId: string) {
    const roles = await this.repo.findAllForOrg(organizationId);
    return roles.map(RolesMapper.toResponse);
  }

  async create(organizationId: string, dto: CreateRoleDto) {
    const existing = await this.repo.findByOrgAndName(organizationId, dto.name);
    if (existing) throw new ConflictException(`Le rôle ${dto.name} existe déjà pour cette organisation.`);

    const permissions = await this.prisma.permission.findMany({ where: { code: { in: dto.permissionCodes } } });
    if (permissions.length !== dto.permissionCodes.length) {
      throw new BadRequestException('Un ou plusieurs codes de permission sont invalides.');
    }

    const role = await this.repo.create(organizationId, dto.name, dto.label);
    const updated = await this.repo.replacePermissions(
      role.id,
      permissions.map((p) => p.id),
    );
    return RolesMapper.toResponse(updated!);
  }

  async updatePermissions(organizationId: string, roleId: string, dto: UpdateRolePermissionsDto) {
    const role = await this.repo.findById(roleId);
    if (!role || role.organizationId !== organizationId) throw new NotFoundException('Rôle introuvable.');

    const permissions = await this.prisma.permission.findMany({ where: { code: { in: dto.permissionCodes } } });
    if (permissions.length !== dto.permissionCodes.length) {
      throw new BadRequestException('Un ou plusieurs codes de permission sont invalides.');
    }

    const updated = await this.repo.replacePermissions(
      roleId,
      permissions.map((p) => p.id),
    );
    return RolesMapper.toResponse(updated!);
  }
}
