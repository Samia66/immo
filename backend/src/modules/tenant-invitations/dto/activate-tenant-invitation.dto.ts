import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength } from 'class-validator';

export class ActivateTenantInvitationDto {
  @ApiProperty({
    description: 'Numéro de téléphone ou adresse email brute (doit correspondre au contact vérifié par OTP).',
  })
  @IsString()
  contact: string;

  @ApiProperty({ description: 'Code OTP à 6 chiffres reçu pour purpose=ACTIVATE_TENANT.' })
  @IsString()
  otpCode: string;

  @ApiProperty()
  @IsString()
  @MinLength(8)
  password: string;

  @ApiProperty()
  @IsString()
  firstName: string;

  @ApiProperty()
  @IsString()
  lastName: string;
}
