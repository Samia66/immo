import { Body, Controller, Get, HttpCode, HttpStatus, Param, Post, Req, Res, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';
import { Throttle } from '@nestjs/throttler';
import { Request, Response } from 'express';
import { TenantInvitationsService } from './tenant-invitations.service';
import { ActivateTenantInvitationDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser, Public } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';
import { AppConfig } from '../../config/configuration';
import { REFRESH_COOKIE_NAME } from '../auth/strategies/jwt-refresh.strategy';

/** Manager-side: generates the activation invitation for a lease. Mounted under /leases to sit next to the lease workflow endpoints. */
@ApiTags('leases')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('leases')
export class LeaseTenantInvitationsController {
  constructor(private readonly service: TenantInvitationsService) {}

  @Post(':id/invite')
  @Permissions('leases:update')
  invite(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.createInvitation(user.organizationId, id);
  }
}

/** Public, pre-auth routes for the tenant's "J'ai reçu une invitation" mobile flow. */
@ApiTags('tenant-invitations')
@Controller('tenant-invitations')
export class TenantInvitationsController {
  constructor(
    private readonly service: TenantInvitationsService,
    private readonly config: ConfigService<AppConfig, true>,
  ) {}

  private setRefreshCookie(res: Response, token: string, expiresAt: Date) {
    const isProd = this.config.get('nodeEnv', { infer: true }) === 'production';
    res.cookie(REFRESH_COOKIE_NAME, token, {
      httpOnly: true,
      secure: isProd,
      sameSite: 'strict' as const,
      path: '/auth',
      expires: expiresAt,
    });
  }

  @Public()
  @Get(':code')
  preview(@Param('code') code: string) {
    return this.service.preview(code);
  }

  @Public()
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @Post(':code/activate')
  @HttpCode(HttpStatus.OK)
  async activate(
    @Param('code') code: string,
    @Body() dto: ActivateTenantInvitationDto,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ) {
    const result = await this.service.activate(code, dto, { ipAddress: req.ip, userAgent: req.headers['user-agent'] });
    this.setRefreshCookie(res, result.refreshToken, result.refreshExpiresAt);
    return { accessToken: result.accessToken, user: result.user };
  }
}
