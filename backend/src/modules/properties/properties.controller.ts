import {
  Body,
  Controller,
  Delete,
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
import { PropertiesService } from './properties.service';
import { PropertyImagesService } from './property-images/property-images.service';
import { CreatePropertyDto, UpdatePropertyDto, QueryPropertyDto, NearbyPropertyDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser, Audit } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';
import { buildDiskStorage, imageFileFilter, MAX_UPLOAD_SIZE_BYTES } from '../../common/utils/file-storage.util';

@ApiTags('properties')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('properties')
export class PropertiesController {
  constructor(
    private readonly service: PropertiesService,
    private readonly imagesService: PropertyImagesService,
  ) {}

  @Get('nearby')
  @Permissions('properties:read')
  nearby(@CurrentUser() user: AuthenticatedUser, @Query() query: NearbyPropertyDto) {
    return this.service.nearby(user.organizationId, query);
  }

  @Get()
  @Permissions('properties:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryPropertyDto) {
    return this.service.findAll(user.organizationId, query);
  }

  @Get(':id')
  @Permissions('properties:read')
  findOne(@Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id);
  }

  @Get(':id/history')
  @Permissions('properties:read_history')
  history(@Param('id', ParseUuidPipe) id: string) {
    return this.service.history(id);
  }

  @Post()
  @Permissions('properties:create')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreatePropertyDto) {
    return this.service.create(user.organizationId, dto);
  }

  @Patch(':id')
  @Permissions('properties:update')
  update(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseUuidPipe) id: string,
    @Body() dto: UpdatePropertyDto,
  ) {
    return this.service.update(id, user.id, dto);
  }

  @Delete(':id')
  @Permissions('properties:delete')
  @Audit('DELETE', 'Property')
  remove(@Param('id', ParseUuidPipe) id: string) {
    return this.service.remove(id);
  }

  @Post(':id/images')
  @Permissions('properties:manage_images')
  @UseInterceptors(
    FilesInterceptor('files', 10, {
      storage: buildDiskStorage('properties'),
      fileFilter: imageFileFilter,
      limits: { fileSize: MAX_UPLOAD_SIZE_BYTES },
    }),
  )
  addImages(@Param('id', ParseUuidPipe) id: string, @UploadedFiles() files: Express.Multer.File[]) {
    return this.imagesService.addImages(id, files ?? []);
  }

  @Delete(':id/images/:imageId')
  @Permissions('properties:manage_images')
  removeImage(@Param('id', ParseUuidPipe) id: string, @Param('imageId', ParseUuidPipe) imageId: string) {
    return this.imagesService.removeImage(id, imageId);
  }
}
