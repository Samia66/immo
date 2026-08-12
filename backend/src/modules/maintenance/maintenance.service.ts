import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { MaintenanceStatus, Prisma, RoleName } from '@prisma/client';
import { MaintenanceRepository } from './maintenance.repository';
import { MaintenanceMapper } from './maintenance.mapper';
import {
  CreateMaintenanceRequestDto,
  AssignMaintenanceDto,
  UpdateMaintenanceStatusDto,
  QueryMaintenanceDto,
} from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthenticatedUser } from '../../common/interfaces';
import {
  isBackwardTransition,
  isForwardTransitionAllowed,
} from '../../common/constants/maintenance-transitions.constant';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class MaintenanceService {
  constructor(
    private readonly repo: MaintenanceRepository,
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
  ) {}

  async findAll(organizationId: string, query: QueryMaintenanceDto) {
    const where: Prisma.MaintenanceRequestWhereInput = { organizationId, deletedAt: null };
    if (query.status) where.status = query.status;
    if (query.priority) where.priority = query.priority;
    if (query.propertyId) where.propertyId = query.propertyId;
    if (query.assignedToId) where.assignedToId = query.assignedToId;

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(MaintenanceMapper.toResponse), total, query.page, query.limit);
  }

  async findOne(id: string, user: AuthenticatedUser) {
    const request = await this.getOwnedOrThrow(id, user);
    return MaintenanceMapper.toResponse(request);
  }

  async myRequests(userId: string, query: QueryMaintenanceDto) {
    const tenant = await this.prisma.tenant.findFirst({ where: { userId } });
    if (!tenant) return new PaginatedResponseDto([], 0, query.page, query.limit);

    const where: Prisma.MaintenanceRequestWhereInput = { tenantId: tenant.id, deletedAt: null };
    if (query.status) where.status = query.status;

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, { createdAt: 'desc' }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(MaintenanceMapper.toResponse), total, query.page, query.limit);
  }

  async create(organizationId: string, user: AuthenticatedUser, dto: CreateMaintenanceRequestDto) {
    const property = await this.prisma.property.findFirst({
      where: { id: dto.propertyId, organizationId, deletedAt: null },
    });
    if (!property) throw new BadRequestException('Bien invalide pour cette organisation.');

    let tenantId = dto.tenantId;
    if (user.roleName === RoleName.LOCATAIRE) {
      tenantId = user.tenantProfileId ?? undefined;
      if (!tenantId) throw new BadRequestException('Aucun profil locataire associé à ce compte.');
    }

    const request = await this.repo.create({
      organization: { connect: { id: organizationId } },
      property: { connect: { id: dto.propertyId } },
      tenant: tenantId ? { connect: { id: tenantId } } : undefined,
      category: dto.category,
      description: dto.description,
      priority: dto.priority ?? 'NORMALE',
      status: 'NOUVELLE',
    });

    await this.notifyManagers(
      organizationId,
      request.id,
      'Nouvelle demande de maintenance',
      `Nouvelle demande: ${dto.category}.`,
    );

    return MaintenanceMapper.toResponse(request);
  }

  async validate(id: string) {
    const request = await this.ensureExists(id);
    this.assertTransition(request.status, 'VALIDEE', false);
    const updated = await this.repo.update(id, { status: 'VALIDEE' });
    await this.notifyParties(updated, 'Demande validée', `Votre demande "${updated.category}" a été validée.`);
    return MaintenanceMapper.toResponse(updated);
  }

  async assign(id: string, dto: AssignMaintenanceDto) {
    const request = await this.ensureExists(id);
    this.assertTransition(request.status, 'ASSIGNEE', false);

    const technician = await this.prisma.user.findFirst({
      where: { id: dto.assignedToId, organizationId: request.organizationId, isActive: true },
    });
    if (!technician) throw new BadRequestException('Technicien invalide pour cette organisation.');

    const updated = await this.repo.update(id, {
      status: 'ASSIGNEE',
      assignedTo: { connect: { id: dto.assignedToId } },
      scheduledAt: dto.scheduledAt ? new Date(dto.scheduledAt) : undefined,
      estimatedCost: dto.estimatedCost,
    });

    await this.notifyParties(
      updated,
      'Technicien assigné',
      `Un technicien a été assigné à la demande "${updated.category}".`,
    );
    await this.notifications.notify({
      organizationId: request.organizationId,
      userId: dto.assignedToId,
      type: 'MAINTENANCE',
      title: 'Nouvelle intervention assignée',
      message: `Vous avez été assigné à la demande "${updated.category}".`,
    });

    return MaintenanceMapper.toResponse(updated);
  }

  async updateStatus(id: string, user: AuthenticatedUser, dto: UpdateMaintenanceStatusDto) {
    const request = await this.ensureExists(id);
    const isAdmin = user.roleName === RoleName.ADMIN_AGENCE;

    this.assertTransition(request.status, dto.status, isAdmin);

    const data: Prisma.MaintenanceRequestUpdateInput = { status: dto.status };
    if (dto.status === 'EN_COURS' && !request.startedAt) data.startedAt = new Date();
    if (dto.status === 'TERMINEE') {
      data.completedAt = new Date();
      if (dto.actualCost !== undefined) data.actualCost = dto.actualCost;
    }

    const updated = await this.repo.update(id, data);
    await this.notifyParties(
      updated,
      'Statut de maintenance mis à jour',
      `La demande "${updated.category}" est maintenant: ${dto.status}.`,
    );
    return MaintenanceMapper.toResponse(updated);
  }

  private assertTransition(from: MaintenanceStatus, to: MaintenanceStatus, isAdmin: boolean) {
    if (from === to) throw new ConflictException('La demande est déjà dans ce statut.');
    if (isForwardTransitionAllowed(from, to)) return;
    if (isAdmin && isBackwardTransition(from, to)) return;
    throw new ConflictException(`Transition de statut invalide: ${from} -> ${to}.`);
  }

  private async notifyParties(
    request: { organizationId: string; tenantId: string | null; assignedToId: string | null; category: string },
    title: string,
    message: string,
  ) {
    if (request.tenantId) {
      const tenant = await this.prisma.tenant.findUnique({ where: { id: request.tenantId } });
      if (tenant?.userId) {
        await this.notifications.notify({
          organizationId: request.organizationId,
          userId: tenant.userId,
          type: 'MAINTENANCE',
          title,
          message,
        });
      }
    }
    if (request.assignedToId) {
      await this.notifications.notify({
        organizationId: request.organizationId,
        userId: request.assignedToId,
        type: 'MAINTENANCE',
        title,
        message,
      });
    }
  }

  private async notifyManagers(organizationId: string, requestId: string, title: string, message: string) {
    const managers = await this.prisma.user.findMany({
      where: { organizationId, isActive: true, role: { name: { in: ['ADMIN_AGENCE', 'GESTIONNAIRE'] } } },
    });
    for (const manager of managers) {
      await this.notifications.notify({
        organizationId,
        userId: manager.id,
        type: 'MAINTENANCE',
        title,
        message,
        metadata: { requestId },
      });
    }
  }

  private async getOwnedOrThrow(id: string, user: AuthenticatedUser) {
    const request = await this.repo.findById(id);
    if (!request) throw new NotFoundException('Demande de maintenance introuvable.');

    if (user.roleName === RoleName.LOCATAIRE) {
      if (request.tenant?.userId !== user.id) {
        throw new ForbiddenException("Vous n'avez pas accès à cette demande.");
      }
    }

    return request;
  }

  private async ensureExists(id: string) {
    const request = await this.repo.findById(id);
    if (!request) throw new NotFoundException('Demande de maintenance introuvable.');
    return request;
  }
}
