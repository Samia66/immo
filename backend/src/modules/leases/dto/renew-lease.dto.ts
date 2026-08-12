import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsOptional, IsString } from 'class-validator';

export class RenewLeaseDto {
  @ApiProperty()
  @IsDateString()
  newEndDate: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  amendmentDescription?: string;
}
