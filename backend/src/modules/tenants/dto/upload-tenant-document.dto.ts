import { ApiProperty } from '@nestjs/swagger';
import { IsIn } from 'class-validator';

export const TENANT_DOCUMENT_TYPES = ['CNI', 'CONTRAT_TRAVAIL', 'CAUTION', 'AUTRE'] as const;

export class UploadTenantDocumentDto {
  @ApiProperty({ enum: TENANT_DOCUMENT_TYPES })
  @IsIn(TENANT_DOCUMENT_TYPES)
  type: (typeof TENANT_DOCUMENT_TYPES)[number];
}
