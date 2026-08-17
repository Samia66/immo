import { ApiPropertyOptional, ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsOptional, IsString, MinLength } from 'class-validator';

export class RegisterDto {
  @ApiPropertyOptional({
    description:
      'Nom de l\'organisation créée pour ce gestionnaire. Si omis/vide, un nom par défaut ("Espace de {prénom} {nom}") est utilisé (spec §5.1).',
  })
  @IsOptional()
  @IsString()
  organizationName?: string;

  @ApiProperty()
  @IsEmail()
  email: string;

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
