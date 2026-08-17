import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { PaymentFrequency } from '@prisma/client';
import { IsDateString, IsEnum, IsInt, IsNumber, IsOptional, IsUUID, Max, Min } from 'class-validator';

export class CreateLeaseDto {
  @ApiProperty()
  @IsUUID()
  propertyUnitId: string;

  @ApiProperty()
  @IsUUID()
  tenantId: string;

  @ApiProperty()
  @IsDateString()
  startDate: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiProperty()
  @IsNumber()
  @Min(0)
  rentAmount: number;

  @ApiProperty()
  @IsNumber()
  @Min(0)
  depositAmount: number;

  @ApiProperty({ enum: PaymentFrequency })
  @IsEnum(PaymentFrequency)
  paymentFrequency: PaymentFrequency;

  @ApiPropertyOptional({
    description: 'Jour du mois (1-28) où le loyer est dû. Par défaut le 5 de chaque mois.',
    default: 5,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(28)
  rentDueDay?: number;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  indexationRate?: number;
}
