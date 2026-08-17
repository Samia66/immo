import { ApiProperty } from '@nestjs/swagger';
import { PropertyType } from '@prisma/client';
import { IsEnum, IsNumber, IsOptional, IsString, IsUUID } from 'class-validator';

export class CreatePropertyDto {
  @ApiProperty()
  @IsString()
  title: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({
    enum: PropertyType,
    description: 'Descripteur du bâtiment/annonce (le détail locatif vit sur PropertyUnit).',
  })
  @IsEnum(PropertyType)
  type: PropertyType;

  @ApiProperty()
  @IsString()
  addressLine: string;

  @ApiProperty()
  @IsString()
  city: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  district?: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  latitude?: number;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  longitude?: number;

  @ApiProperty()
  @IsUUID()
  ownerId: string;
}
