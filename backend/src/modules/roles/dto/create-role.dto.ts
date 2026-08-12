import { ApiProperty } from '@nestjs/swagger';
import { RoleName } from '@prisma/client';
import { ArrayUnique, IsArray, IsEnum, IsString, NotEquals } from 'class-validator';

/**
 * NOTE: the Prisma schema (spec §5) models `Role.name` as the closed `RoleName` enum with
 * `@@unique([organizationId, name])`, not a free-text field. This means an organization can
 * only ever have one Role row per enum value — there is no way to create arbitrary/unlimited
 * custom role names without altering the schema (which the task asked to keep essentially
 * verbatim). This endpoint is therefore only meaningful for a RoleName that doesn't yet exist
 * for the organization (e.g. re-provisioning a role after a migration); SUPER_ADMIN is excluded.
 */
export class CreateRoleDto {
  @ApiProperty({ enum: RoleName })
  @IsEnum(RoleName)
  @NotEquals('SUPER_ADMIN')
  name: Exclude<RoleName, 'SUPER_ADMIN'>;

  @ApiProperty()
  @IsString()
  label: string;

  @ApiProperty({ type: [String], description: 'Codes de permissions initiaux (ex: "properties:read")' })
  @IsArray()
  @ArrayUnique()
  @IsString({ each: true })
  permissionCodes: string[];
}
