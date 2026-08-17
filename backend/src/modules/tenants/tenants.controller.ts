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
import { TenantsService } from './tenants.service';
import { CreateTenantDto, UpdateTenantDto, QueryTenantDto, UploadTenantDocumentDto, LinkTenantUserDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';
import { buildDiskStorage, documentFileFilter, MAX_UPLOAD_SIZE_BYTES } from '../../common/utils/file-storage.util';

@ApiTags('tenants')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('tenants')
export class TenantsController {
  constructor(private readonly service: TenantsService) {}

  @Get()
  @Permissions('tenants:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryTenantDto) {
    return this.service.findAll(user, query);
  }

  @Get(':id')
  @Permissions('tenants:read_detail')
  findOne(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id, user);
  }

  @Post()
  @Permissions('tenants:create')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreateTenantDto) {
    return this.service.create(user, dto);
  }

  @Patch(':id')
  @Permissions('tenants:update')
  update(@Param('id', ParseUuidPipe) id: string, @Body() dto: UpdateTenantDto) {
    return this.service.update(id, dto);
  }

  @Patch(':id/link-user')
  @Permissions('tenants:update')
  linkUser(@Param('id', ParseUuidPipe) id: string, @Body() dto: LinkTenantUserDto) {
    return this.service.linkUser(id, dto);
  }

  @Post(':id/documents')
  @Permissions('tenants:manage_documents')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: buildDiskStorage('tenants'),
      fileFilter: documentFileFilter,
      limits: { fileSize: MAX_UPLOAD_SIZE_BYTES },
    }),
  )
  addDocument(
    @Param('id', ParseUuidPipe) id: string,
    @Body() dto: UploadTenantDocumentDto,
    @UploadedFile() file: Express.Multer.File,
  ) {
    return this.service.addDocument(id, dto.type, file);
  }

  @Delete(':id')
  @Permissions('tenants:delete')
  remove(@Param('id', ParseUuidPipe) id: string) {
    return this.service.remove(id);
  }
}
