import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsBooleanString, IsOptional } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto';

export class QueryNotificationDto extends PaginationQueryDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsBooleanString()
  isRead?: string;
}
