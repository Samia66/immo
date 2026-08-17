import { Body, Controller, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { LeasesService } from './leases.service';
import {
  CreateLeaseDto,
  UpdateLeaseDto,
  TerminateLeaseDto,
  RenewLeaseDto,
  AddAmendmentDto,
  QueryLeaseDto,
  RefuseLeaseDto,
} from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser, Audit } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';

/**
 * `leases:update, leases:read_detail` on the tenant-facing workflow steps (acknowledge/accept/
 * refuse) mirrors the pattern used elsewhere (see visits.controller.ts's `@Permissions('visits:read',
 * 'visits:read_own')`): it lets EITHER a manager (leases:update) OR the tenant (whose role only
 * carries leases:read_detail) through the coarse permission gate, with LeasesService's
 * `getOwnedOrThrow` enforcing that a LOCATAIRE caller only ever touches their own lease.
 */
const TENANT_WORKFLOW_PERMISSIONS = ['leases:update', 'leases:read_detail'] as const;

@ApiTags('leases')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('leases')
export class LeasesController {
  constructor(private readonly service: LeasesService) {}

  @Get('expiring-soon')
  @Permissions('leases:read_expiring')
  expiringSoon(@CurrentUser() user: AuthenticatedUser, @Query('days') days?: string) {
    return this.service.expiringSoon(user.organizationId, days ? parseInt(days, 10) : 30);
  }

  @Get()
  @Permissions('leases:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryLeaseDto) {
    return this.service.findAll(user.organizationId, user, query);
  }

  @Get(':id')
  @Permissions('leases:read_detail')
  findOne(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id, user);
  }

  @Get(':id/contract.pdf')
  @Permissions('leases:read_contract_pdf')
  contractPdf(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.contractPdf(id, user);
  }

  @Post()
  @Permissions('leases:create')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreateLeaseDto) {
    return this.service.create(user.organizationId, user, dto);
  }

  @Patch(':id')
  @Permissions('leases:update')
  update(@Param('id', ParseUuidPipe) id: string, @Body() dto: UpdateLeaseDto) {
    return this.service.update(id, dto);
  }

  @Post(':id/renew')
  @Permissions('leases:renew')
  @Audit('UPDATE', 'Lease')
  renew(@Param('id', ParseUuidPipe) id: string, @Body() dto: RenewLeaseDto) {
    return this.service.renew(id, dto);
  }

  @Post(':id/terminate')
  @Permissions('leases:terminate')
  @Audit('LEASE_TERMINATED', 'Lease')
  terminate(@Param('id', ParseUuidPipe) id: string, @Body() dto: TerminateLeaseDto) {
    return this.service.terminate(id, dto);
  }

  @Post(':id/amendments')
  @Permissions('leases:manage_amendments')
  addAmendment(@Param('id', ParseUuidPipe) id: string, @Body() dto: AddAmendmentDto) {
    return this.service.addAmendment(id, dto);
  }

  @Post(':id/send')
  @Permissions('leases:update')
  send(@CurrentUser('id') userId: string, @Param('id', ParseUuidPipe) id: string) {
    return this.service.send(id, userId);
  }

  @Post(':id/acknowledge')
  @Permissions(...TENANT_WORKFLOW_PERMISSIONS)
  acknowledge(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.acknowledge(id, user);
  }

  @Post(':id/accept')
  @Permissions(...TENANT_WORKFLOW_PERMISSIONS)
  accept(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.accept(id, user);
  }

  @Post(':id/refuse')
  @Permissions(...TENANT_WORKFLOW_PERMISSIONS)
  refuse(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string, @Body() dto: RefuseLeaseDto) {
    return this.service.refuse(id, user, dto);
  }

  @Post(':id/cancel')
  @Permissions('leases:update')
  cancel(@CurrentUser('id') userId: string, @Param('id', ParseUuidPipe) id: string) {
    return this.service.cancel(id, userId);
  }
}
