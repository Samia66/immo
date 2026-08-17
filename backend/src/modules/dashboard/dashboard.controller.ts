import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { DashboardService } from './dashboard.service';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser } from '../../common/decorators';
import { AuthenticatedUser } from '../../common/interfaces';

@ApiTags('dashboard')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('dashboard')
export class DashboardController {
  constructor(private readonly service: DashboardService) {}

  @Get('admin')
  @Permissions('dashboard:admin')
  admin(@CurrentUser() user: AuthenticatedUser) {
    return this.service.adminDashboard(user.organizationId);
  }

  @Get('manager')
  @Permissions('dashboard:manager')
  manager(@CurrentUser('id') userId: string) {
    return this.service.managerDashboard(userId);
  }

  @Get('tenant')
  @Permissions('dashboard:tenant')
  tenant(@CurrentUser('id') userId: string) {
    return this.service.tenantDashboard(userId);
  }

  @Get('owner')
  @Permissions('dashboard:owner')
  owner(@CurrentUser('id') userId: string) {
    return this.service.ownerDashboard(userId);
  }

  @Get('super-admin')
  @Permissions('dashboard:super_admin')
  superAdmin() {
    return this.service.superAdminDashboard();
  }
}
