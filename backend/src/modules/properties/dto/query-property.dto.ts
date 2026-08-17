import { ApiPropertyOptional } from '@nestjs/swagger';
import { PropertyStatus, PropertyType } from '@prisma/client';
import { Type } from 'class-transformer';
import { IsEnum, IsNumber, IsOptional, IsString } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto';

export class QueryPropertyDto extends PaginationQueryDto {
  @ApiPropertyOptional({ enum: PropertyType, description: 'Type de bâtiment/annonce (Property.type).' })
  @IsOptional()
  @IsEnum(PropertyType)
  type?: PropertyType;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  city?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({
    enum: PropertyStatus,
    description: 'Ne renvoie que les biens ayant au moins un lot dans ce statut.',
  })
  @IsOptional()
  @IsEnum(PropertyStatus)
  unitStatus?: PropertyStatus;

  @ApiPropertyOptional({
    description: 'Ne renvoie que les biens ayant au moins un lot avec un loyer >= à cette valeur.',
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  minRent?: number;

  @ApiPropertyOptional({
    description: 'Ne renvoie que les biens ayant au moins un lot avec un loyer <= à cette valeur.',
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  maxRent?: number;
}
