import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';

export class LinkTenantUserDto {
  @ApiProperty({ description: 'ID du compte User (rôle LOCATAIRE) à lier à ce locataire.' })
  @IsUUID()
  userId: string;
}
