import { Module } from '@nestjs/common';
import { MaintenanceController } from './maintenance.controller';
import { MaintenanceService } from './maintenance.service';
import { MaintenanceRepository } from './maintenance.repository';
import { MaintenanceAttachmentsService } from './maintenance-attachments/maintenance-attachments.service';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [NotificationsModule],
  controllers: [MaintenanceController],
  providers: [MaintenanceService, MaintenanceRepository, MaintenanceAttachmentsService],
  exports: [MaintenanceService],
})
export class MaintenanceModule {}
