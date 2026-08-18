import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { WorkersService } from './workers.service';
import { CreateWorkerDto, UpdateWorkerDto, QueryWorkerDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';

@ApiTags('workers')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('workers')
export class WorkersController {
  constructor(private readonly service: WorkersService) {}

  @Get('me')
  @Permissions('workers:read_own')
  myWorkers(@CurrentUser('id') userId: string) {
    return this.service.myWorkers(userId);
  }

  @Get()
  @Permissions('workers:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryWorkerDto) {
    return this.service.findAll(user, query);
  }

  @Get(':id')
  @Permissions('workers:read')
  findOne(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id, user);
  }

  @Post()
  @Permissions('workers:create')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreateWorkerDto) {
    return this.service.create(user, dto);
  }

  @Patch(':id')
  @Permissions('workers:update')
  update(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseUuidPipe) id: string,
    @Body() dto: UpdateWorkerDto,
  ) {
    return this.service.update(id, user, dto);
  }

  @Delete(':id')
  @Permissions('workers:delete')
  remove(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.remove(id, user);
  }
}
