import { Module } from '@nestjs/common';
import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';
import { NotificationsScheduler } from './notifications.scheduler';
import { InAppChannel } from './channels/inapp.channel';
import { EmailChannel } from './channels/email.channel';
import { SmsChannel } from './channels/sms.channel';

@Module({
  controllers: [NotificationsController],
  providers: [NotificationsService, NotificationsScheduler, InAppChannel, EmailChannel, SmsChannel],
  exports: [NotificationsService],
})
export class NotificationsModule {}
