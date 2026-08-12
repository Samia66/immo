import { Body, Controller, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { OrganizationsService } from './organizations.service';
import { CreateOrganizationDto, UpdateOrganizationDto, UpdateSubscriptionDto, QueryOrganizationDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser, Audit } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';

@ApiTags('organizations')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('organizations')
export class OrganizationsController {
  constructor(private readonly service: OrganizationsService) {}

  @Get()
  @Permissions('organizations:read_all')
  findAll(@Query() query: QueryOrganizationDto) {
    return this.service.findAll(query);
  }

  @Get('me')
  @Permissions('organizations:read_own')
  findMe(@CurrentUser() user: AuthenticatedUser) {
    return this.service.findMe(user.organizationId);
  }

  @Patch('me')
  @Permissions('organizations:update_own')
  updateMe(@CurrentUser() user: AuthenticatedUser, @Body() dto: UpdateOrganizationDto) {
    return this.service.updateMe(user.organizationId, dto);
  }

  @Get(':id')
  @Permissions('organizations:read_all')
  findOne(@Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id);
  }

  @Post()
  @Permissions('organizations:create')
  create(@Body() dto: CreateOrganizationDto) {
    return this.service.create(dto);
  }

  @Patch(':id')
  @Permissions('organizations:update')
  update(@Param('id', ParseUuidPipe) id: string, @Body() dto: UpdateOrganizationDto) {
    return this.service.update(id, dto);
  }

  @Patch(':id/subscription')
  @Permissions('organizations:manage_subscription')
  updateSubscription(@Param('id', ParseUuidPipe) id: string, @Body() dto: UpdateSubscriptionDto) {
    return this.service.updateSubscription(id, dto);
  }

  @Patch(':id/toggle-active')
  @Permissions('organizations:toggle_active')
  @Audit('UPDATE', 'Organization')
  toggleActive(@Param('id', ParseUuidPipe) id: string) {
    return this.service.toggleActive(id);
  }
}
