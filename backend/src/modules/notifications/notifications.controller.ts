import { Controller, Get, Param, Patch, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { NotificationsService } from './notifications.service';
import { QueryNotificationDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';

@ApiTags('notifications')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('notifications')
export class NotificationsController {
  constructor(private readonly service: NotificationsService) {}

  @Get('unread-count')
  @Permissions('notifications:read')
  unreadCount(@CurrentUser('id') userId: string) {
    return this.service.unreadCount(userId);
  }

  @Get()
  @Permissions('notifications:read')
  findAll(@CurrentUser('id') userId: string, @Query() query: QueryNotificationDto) {
    return this.service.findAll(userId, query);
  }

  @Patch('read-all')
  @Permissions('notifications:manage')
  markAllRead(@CurrentUser('id') userId: string) {
    return this.service.markAllRead(userId);
  }

  @Patch(':id/read')
  @Permissions('notifications:manage')
  markRead(@CurrentUser('id') userId: string, @Param('id', ParseUuidPipe) id: string) {
    return this.service.markRead(userId, id);
  }
}
