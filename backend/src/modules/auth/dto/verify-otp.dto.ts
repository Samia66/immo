import { ApiProperty } from '@nestjs/swagger';
import { OtpPurpose } from '@prisma/client';
import { IsEnum, IsString } from 'class-validator';

export class VerifyOtpDto {
  @ApiProperty({ description: 'Numéro de téléphone ou adresse email brute.' })
  @IsString()
  contact: string;

  @ApiProperty({ enum: OtpPurpose })
  @IsEnum(OtpPurpose)
  purpose: OtpPurpose;

  @ApiProperty()
  @IsString()
  code: string;
}
