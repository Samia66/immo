import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { PropertyType } from '@prisma/client';
import { IsEnum, IsInt, IsNumber, IsOptional, IsString, Min } from 'class-validator';

export class CreatePropertyUnitDto {
  @ApiProperty({ description: 'Référence unique au sein du bien, ex: "A-203".' })
  @IsString()
  reference: string;

  @ApiPropertyOptional({ description: 'Libellé affiché, ex: "Appartement A-203".' })
  @IsOptional()
  @IsString()
  label?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  floor?: string;

  @ApiProperty({ enum: PropertyType })
  @IsEnum(PropertyType)
  type: PropertyType;

  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(0)
  rooms?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  @Min(0)
  surfaceM2?: number;

  @ApiProperty()
  @IsNumber()
  @Min(0)
  monthlyRent: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  @Min(0)
  monthlyCharges?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  description?: string;
}
