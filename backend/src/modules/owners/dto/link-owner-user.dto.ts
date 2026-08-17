import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';

export class LinkOwnerUserDto {
  @ApiProperty({ description: 'ID du compte User (rôle PROPRIETAIRE) à lier à ce propriétaire.' })
  @IsUUID()
  userId: string;
}
