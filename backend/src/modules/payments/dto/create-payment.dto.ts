import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsNumber, IsUUID, Min } from 'class-validator';

/** Manually generates a rent installment ("échéance") for a lease, outside the monthly cron job. */
export class CreatePaymentDto {
  @ApiProperty()
  @IsUUID()
  leaseId: string;

  @ApiProperty()
  @IsNumber()
  @Min(0)
  amountDue: number;

  @ApiProperty()
  @IsDateString()
  dueDate: string;
}
