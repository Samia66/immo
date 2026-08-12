import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-jwt';
import { Request } from 'express';
import { RefreshJwtPayload } from '../../../common/interfaces/jwt-payload.interface';
import { AppConfig } from '../../../config/configuration';

const REFRESH_COOKIE_NAME = 'refreshToken';

function cookieExtractor(req: Request): string | null {
  return req?.cookies?.[REFRESH_COOKIE_NAME] ?? null;
}

@Injectable()
export class JwtRefreshStrategy extends PassportStrategy(Strategy, 'jwt-refresh') {
  constructor(private readonly config: ConfigService<AppConfig, true>) {
    super({
      jwtFromRequest: cookieExtractor,
      ignoreExpiration: false,
      secretOrKey: config.get('jwt.refreshSecret', { infer: true }),
      passReqToCallback: true,
    });
  }

  async validate(req: Request, payload: RefreshJwtPayload) {
    // Raw cookie value re-attached so the service can hash-compare it against the stored token.
    return { ...payload, rawToken: cookieExtractor(req) };
  }
}

export { REFRESH_COOKIE_NAME };
