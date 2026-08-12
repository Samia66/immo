import { ApiProperty } from '@nestjs/swagger';
import { VisitStatus } from '@prisma/client';
import { IsIn, IsString } from 'class-validator';

export class CompleteVisitDto {
  @ApiProperty({ enum: ['REALISEE', 'ANNULEE'] })
  @IsIn(['REALISEE', 'ANNULEE'])
  status: Extract<VisitStatus, 'REALISEE' | 'ANNULEE'>;

  @ApiProperty()
  @IsString()
  outcome: string;
}
