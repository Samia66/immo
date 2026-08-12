import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsNumber, IsOptional } from 'class-validator';

export class NearbyPropertyDto {
  @ApiProperty()
  @Type(() => Number)
  @IsNumber()
  lat: number;

  @ApiProperty()
  @Type(() => Number)
  @IsNumber()
  lng: number;

  @ApiPropertyOptional({ description: 'Rayon de recherche en kilomètres (défaut 5)' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  radius?: number;
}
