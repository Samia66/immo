import { ApiPropertyOptional, PartialType } from '@nestjs/swagger';
import { PropertyStatus } from '@prisma/client';
import { IsEnum, IsOptional } from 'class-validator';
import { CreatePropertyUnitDto } from './create-property-unit.dto';

export class UpdatePropertyUnitDto extends PartialType(CreatePropertyUnitDto) {
  @ApiPropertyOptional({ enum: PropertyStatus })
  @IsOptional()
  @IsEnum(PropertyStatus)
  status?: PropertyStatus;
}
