import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { PaginatedResponseDto } from '../../common/dto';
import { QueryAuditLogDto } from './dto/query-audit-log.dto';

@Injectable()
export class AuditLogService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * `organizationId: null` means "no explicit org filter" (SUPER_ADMIN, global view — the
   * tenant middleware already no-ops for SUPER_ADMIN context, see prisma.service.ts).
   */
  async findAll(organizationId: string | null, query: QueryAuditLogDto) {
    const where: Prisma.AuditLogWhereInput = {};
    if (organizationId) where.organizationId = organizationId;
    if (query.action) where.action = query.action;
    if (query.entity) where.entity = query.entity;

    const [items, total] = await Promise.all([
      this.prisma.auditLog.findMany({
        where,
        skip: (query.page - 1) * query.limit,
        take: query.limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.auditLog.count({ where }),
    ]);

    return new PaginatedResponseDto(items, total, query.page, query.limit);
  }
}
