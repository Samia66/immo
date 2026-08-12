import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsString } from 'class-validator';

export class AddAmendmentDto {
  @ApiProperty()
  @IsString()
  description: string;

  @ApiProperty()
  @IsDateString()
  effectiveDate: string;
}
