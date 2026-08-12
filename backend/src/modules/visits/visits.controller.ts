import { Body, Controller, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { VisitsService } from './visits.service';
import { CreateVisitDto, UpdateVisitDto, CompleteVisitDto, QueryVisitDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';

@ApiTags('visits')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('visits')
export class VisitsController {
  constructor(private readonly service: VisitsService) {}

  @Get('me')
  @Permissions('visits:read_own')
  myVisits(@CurrentUser('id') userId: string, @Query() query: QueryVisitDto) {
    return this.service.myVisits(userId, query);
  }

  @Get()
  @Permissions('visits:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryVisitDto) {
    return this.service.findAll(user.organizationId, query);
  }

  @Get(':id')
  @Permissions('visits:read', 'visits:read_own')
  findOne(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id, user);
  }

  @Post()
  @Permissions('visits:create')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreateVisitDto) {
    return this.service.create(user.organizationId, user, dto);
  }

  @Patch(':id')
  @Permissions('visits:update')
  update(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string, @Body() dto: UpdateVisitDto) {
    return this.service.update(id, user, dto);
  }

  @Patch(':id/complete')
  @Permissions('visits:manage_outcome')
  complete(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseUuidPipe) id: string,
    @Body() dto: CompleteVisitDto,
  ) {
    return this.service.complete(id, user, dto);
  }
}
