import { Module } from '@nestjs/common';
import { LeasesController } from './leases.controller';
import { LeasesService } from './leases.service';
import { LeasesRepository } from './leases.repository';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [NotificationsModule],
  controllers: [LeasesController],
  providers: [LeasesService, LeasesRepository],
  exports: [LeasesService],
})
export class LeasesModule {}
