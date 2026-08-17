import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { OwnersService } from './owners.service';
import { CreateOwnerDto, UpdateOwnerDto, QueryOwnerDto, LinkOwnerUserDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';

@ApiTags('owners')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('owners')
export class OwnersController {
  constructor(private readonly service: OwnersService) {}

  @Get()
  @Permissions('owners:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryOwnerDto) {
    return this.service.findAll(user, query);
  }

  @Get(':id')
  @Permissions('owners:read')
  findOne(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id, user);
  }

  @Post()
  @Permissions('owners:create')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreateOwnerDto) {
    return this.service.create(user.organizationId, dto);
  }

  @Patch(':id')
  @Permissions('owners:update')
  update(@Param('id', ParseUuidPipe) id: string, @Body() dto: UpdateOwnerDto) {
    return this.service.update(id, dto);
  }

  @Patch(':id/link-user')
  @Permissions('owners:update')
  linkUser(@Param('id', ParseUuidPipe) id: string, @Body() dto: LinkOwnerUserDto) {
    return this.service.linkUser(id, dto);
  }

  @Delete(':id')
  @Permissions('owners:delete')
  remove(@Param('id', ParseUuidPipe) id: string) {
    return this.service.remove(id);
  }
}
