import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsIn, IsOptional } from 'class-validator';

export const EXPENSE_REPORT_GROUP_BY = ['property', 'category', 'month'] as const;

export class ExpenseReportQueryDto {
  @ApiProperty({ enum: EXPENSE_REPORT_GROUP_BY })
  @IsIn(EXPENSE_REPORT_GROUP_BY)
  groupBy: (typeof EXPENSE_REPORT_GROUP_BY)[number];

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  fromDate?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  toDate?: string;
}
