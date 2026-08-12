import { RoleName } from '@prisma/client';

export interface JwtPayload {
  sub: string; // userId
  organizationId: string;
  roleId: string;
  roleName: RoleName;
  email: string;
}

export interface RefreshJwtPayload {
  sub: string; // userId
  tokenId: string; // RefreshToken.id, allows rotation/revocation lookups
}
