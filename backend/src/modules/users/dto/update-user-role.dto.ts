import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';

export class UpdateUserRoleDto {
  @ApiProperty()
  @IsUUID()
  roleId: string;
}
