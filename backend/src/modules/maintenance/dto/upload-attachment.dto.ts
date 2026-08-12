import { ApiProperty } from '@nestjs/swagger';
import { IsIn } from 'class-validator';

export const MAINTENANCE_ATTACHMENT_PHASES = ['AVANT', 'APRES'] as const;

export class UploadMaintenanceAttachmentDto {
  @ApiProperty({ enum: MAINTENANCE_ATTACHMENT_PHASES })
  @IsIn(MAINTENANCE_ATTACHMENT_PHASES)
  phase: (typeof MAINTENANCE_ATTACHMENT_PHASES)[number];
}
