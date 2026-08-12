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
} from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser, Audit } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';

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
    return this.service.findAll(user.organizationId, query);
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
    return this.service.create(user.organizationId, dto);
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
}
