import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class RefuseLeaseDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  reason?: string;
}
