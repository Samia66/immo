import { ApiProperty } from '@nestjs/swagger';
import { PaymentFrequency } from '@prisma/client';
import { IsDateString, IsEnum, IsNumber, IsOptional, IsUUID, Min } from 'class-validator';

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

  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  indexationRate?: number;
}
