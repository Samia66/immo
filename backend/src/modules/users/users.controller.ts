import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { CreateUserDto, UpdateUserDto, UpdateUserRoleDto, QueryUserDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser, Audit } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';
import { buildDiskStorage, imageFileFilter, MAX_UPLOAD_SIZE_BYTES } from '../../common/utils/file-storage.util';

@ApiTags('users')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('users')
export class UsersController {
  constructor(private readonly service: UsersService) {}

  @Get()
  @Permissions('users:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryUserDto) {
    return this.service.findAll(user.organizationId, query);
  }

  @Get(':id')
  @Permissions('users:read')
  findOne(@Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id);
  }

  @Post()
  @Permissions('users:create')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreateUserDto) {
    return this.service.create(user.organizationId, dto);
  }

  @Patch(':id')
  @Permissions('users:update')
  update(@Param('id', ParseUuidPipe) id: string, @Body() dto: UpdateUserDto) {
    return this.service.update(id, dto);
  }

  @Patch(':id/role')
  @Permissions('users:change_role')
  @Audit('ROLE_CHANGED', 'User')
  updateRole(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseUuidPipe) id: string,
    @Body() dto: UpdateUserRoleDto,
  ) {
    return this.service.updateRole(user.organizationId, id, dto);
  }

  @Patch(':id/toggle-active')
  @Permissions('users:toggle_active')
  toggleActive(@Param('id', ParseUuidPipe) id: string) {
    return this.service.toggleActive(id);
  }

  @Post(':id/avatar')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: buildDiskStorage('avatars'),
      fileFilter: imageFileFilter,
      limits: { fileSize: MAX_UPLOAD_SIZE_BYTES },
    }),
  )
  uploadAvatar(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseUuidPipe) id: string,
    @UploadedFile() file: Express.Multer.File,
  ) {
    const canManageOthers = user.permissions.includes('users:upload_avatar');
    return this.service.uploadAvatar(user.id, canManageOthers, id, file);
  }

  @Delete(':id')
  @Permissions('users:delete')
  @Audit('DELETE', 'User')
  remove(@Param('id', ParseUuidPipe) id: string) {
    return this.service.remove(id);
  }
}
