import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { RoleName } from '@prisma/client';
import { AuditLogService } from './audit-log.service';
import { QueryAuditLogDto } from './dto/query-audit-log.dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser } from '../../common/decorators';
import { AuthenticatedUser } from '../../common/interfaces';

@ApiTags('audit-log')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('audit-logs')
export class AuditLogController {
  constructor(private readonly service: AuditLogService) {}

  @Get()
  @Permissions('audit-log:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryAuditLogDto) {
    const organizationId = user.roleName === RoleName.SUPER_ADMIN ? null : user.organizationId;
    return this.service.findAll(organizationId, query);
  }
}
