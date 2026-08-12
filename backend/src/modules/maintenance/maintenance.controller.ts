import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UploadedFiles,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { MaintenanceService } from './maintenance.service';
import { MaintenanceAttachmentsService } from './maintenance-attachments/maintenance-attachments.service';
import {
  CreateMaintenanceRequestDto,
  AssignMaintenanceDto,
  UpdateMaintenanceStatusDto,
  QueryMaintenanceDto,
  UploadMaintenanceAttachmentDto,
} from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';
import { buildDiskStorage, imageFileFilter, MAX_UPLOAD_SIZE_BYTES } from '../../common/utils/file-storage.util';

@ApiTags('maintenance')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('maintenance')
export class MaintenanceController {
  constructor(
    private readonly service: MaintenanceService,
    private readonly attachmentsService: MaintenanceAttachmentsService,
  ) {}

  @Get('me')
  @Permissions('maintenance:read_own')
  myRequests(@CurrentUser('id') userId: string, @Query() query: QueryMaintenanceDto) {
    return this.service.myRequests(userId, query);
  }

  @Get()
  @Permissions('maintenance:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryMaintenanceDto) {
    return this.service.findAll(user.organizationId, query);
  }

  @Get(':id')
  @Permissions('maintenance:read_detail')
  findOne(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id, user);
  }

  @Post()
  @Permissions('maintenance:create')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreateMaintenanceRequestDto) {
    return this.service.create(user.organizationId, user, dto);
  }

  @Patch(':id/validate')
  @Permissions('maintenance:validate')
  validate(@Param('id', ParseUuidPipe) id: string) {
    return this.service.validate(id);
  }

  @Patch(':id/assign')
  @Permissions('maintenance:assign')
  assign(@Param('id', ParseUuidPipe) id: string, @Body() dto: AssignMaintenanceDto) {
    return this.service.assign(id, dto);
  }

  @Patch(':id/status')
  @Permissions('maintenance:update_status')
  updateStatus(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseUuidPipe) id: string,
    @Body() dto: UpdateMaintenanceStatusDto,
  ) {
    return this.service.updateStatus(id, user, dto);
  }

  @Post(':id/attachments')
  @Permissions('maintenance:manage_attachments')
  @UseInterceptors(
    FilesInterceptor('files', 10, {
      storage: buildDiskStorage('maintenance'),
      fileFilter: imageFileFilter,
      limits: { fileSize: MAX_UPLOAD_SIZE_BYTES },
    }),
  )
  addAttachments(
    @Param('id', ParseUuidPipe) id: string,
    @Body() dto: UploadMaintenanceAttachmentDto,
    @UploadedFiles() files: Express.Multer.File[],
  ) {
    return this.attachmentsService.addAttachments(id, dto.phase, files ?? []);
  }
}
