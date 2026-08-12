import { RoleName } from '@prisma/client';

export class AuthUserDto {
  id: string;
  organizationId: string;
  email: string;
  firstName: string;
  lastName: string;
  roleName: RoleName;
  permissions: string[];
  isEmailVerified: boolean;
}

export class AuthResponseDto {
  accessToken: string;
  user: AuthUserDto;
}
