import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { PaymentMethod } from '@prisma/client';
import { IsDateString, IsEnum, IsNumber, IsOptional, IsString, Min } from 'class-validator';

/**
 * NOTE: spec §6.4 shows `RecordPaymentDto` carrying a `leaseId`. Since this DTO is used on the
 * id-scoped route `POST /payments/:id/record` (spec §7.9), the target payment is already known
 * from the path parameter, so `leaseId` is redundant here and intentionally omitted.
 */
export class RecordPaymentDto {
  @ApiProperty()
  @IsNumber()
  @Min(0)
  amountPaid: number;

  @ApiProperty({ enum: PaymentMethod })
  @IsEnum(PaymentMethod)
  method: PaymentMethod;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  transactionRef?: string;

  @ApiProperty()
  @IsDateString()
  paidAt: string;
}
