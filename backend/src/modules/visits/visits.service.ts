import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { VisitsRepository } from './visits.repository';
import { VisitsMapper } from './visits.mapper';
import { CreateVisitDto, UpdateVisitDto, CompleteVisitDto, QueryVisitDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthenticatedUser } from '../../common/interfaces';

@Injectable()
export class VisitsService {
  constructor(
    private readonly repo: VisitsRepository,
    private readonly prisma: PrismaService,
  ) {}

  async findAll(organizationId: string, query: QueryVisitDto) {
    const where = this.buildWhere({ organizationId, deletedAt: null }, query);

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'scheduledAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(VisitsMapper.toResponse), total, query.page, query.limit);
  }

  async myVisits(userId: string, query: QueryVisitDto) {
    const where = this.buildWhere({ agentId: userId, deletedAt: null }, query);

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'scheduledAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(VisitsMapper.toResponse), total, query.page, query.limit);
  }

  async findOne(id: string, user: AuthenticatedUser) {
    const visit = await this.getOwnedOrThrow(id, user);
    return VisitsMapper.toResponse(visit);
  }

  async create(organizationId: string, user: AuthenticatedUser, dto: CreateVisitDto) {
    const property = await this.prisma.property.findFirst({
      where: { id: dto.propertyId, organizationId, deletedAt: null },
    });
    if (!property) throw new BadRequestException('Bien invalide pour cette organisation.');

    const visit = await this.repo.create({
      organization: { connect: { id: organizationId } },
      property: { connect: { id: dto.propertyId } },
      agent: { connect: { id: user.id } },
      clientName: dto.clientName,
      clientPhone: dto.clientPhone,
      clientEmail: dto.clientEmail,
      scheduledAt: new Date(dto.scheduledAt),
      notes: dto.notes,
      status: 'PLANIFIEE',
    });

    return VisitsMapper.toResponse(visit);
  }

  async update(id: string, user: AuthenticatedUser, dto: UpdateVisitDto) {
    const visit = await this.getOwnedOrThrow(id, user);
    if (visit.status !== 'PLANIFIEE') {
      throw new ConflictException('Seule une visite planifiée peut être modifiée.');
    }

    if (dto.propertyId) {
      const property = await this.prisma.property.findFirst({
        where: { id: dto.propertyId, organizationId: visit.organizationId, deletedAt: null },
      });
      if (!property) throw new BadRequestException('Bien invalide pour cette organisation.');
    }

    const updated = await this.repo.update(id, {
      ...(dto.propertyId !== undefined && { property: { connect: { id: dto.propertyId } } }),
      clientName: dto.clientName,
      clientPhone: dto.clientPhone,
      clientEmail: dto.clientEmail,
      scheduledAt: dto.scheduledAt !== undefined ? new Date(dto.scheduledAt) : undefined,
      notes: dto.notes,
    });

    return VisitsMapper.toResponse(updated);
  }

  async complete(id: string, user: AuthenticatedUser, dto: CompleteVisitDto) {
    const visit = await this.getOwnedOrThrow(id, user);
    if (visit.status !== 'PLANIFIEE') {
      throw new ConflictException('Seule une visite planifiée peut être clôturée.');
    }

    const updated = await this.repo.update(id, { status: dto.status, outcome: dto.outcome });
    return VisitsMapper.toResponse(updated);
  }

  private buildWhere(base: Prisma.VisitWhereInput, query: QueryVisitDto): Prisma.VisitWhereInput {
    const where: Prisma.VisitWhereInput = { ...base };
    if (query.status) where.status = query.status;
    if (query.propertyId) where.propertyId = query.propertyId;
    if (query.agentId) where.agentId = query.agentId;
    if (query.dateFrom || query.dateTo) {
      where.scheduledAt = {};
      if (query.dateFrom) where.scheduledAt.gte = new Date(query.dateFrom);
      if (query.dateTo) where.scheduledAt.lte = new Date(query.dateTo);
    }
    return where;
  }

  private async getOwnedOrThrow(id: string, user: AuthenticatedUser) {
    const visit = await this.repo.findById(id);
    if (!visit) throw new NotFoundException('Visite introuvable.');

    if (!user.permissions.includes('visits:read') && visit.agentId !== user.id) {
      throw new ForbiddenException("Vous n'avez pas accès à cette visite.");
    }

    return visit;
  }
}
