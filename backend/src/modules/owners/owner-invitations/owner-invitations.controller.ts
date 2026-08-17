import { Body, Controller, Get, HttpCode, HttpStatus, Param, Post, Query, Req, Res, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';
import { Throttle } from '@nestjs/throttler';
import { Request, Response } from 'express';
import { OwnerInvitationsService } from './owner-invitations.service';
import { CreateOwnerInvitationDto, AcceptOwnerInvitationDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../../common/guards';
import { Permissions, CurrentUser, Public } from '../../../common/decorators';
import { ParseUuidPipe } from '../../../common/pipes';
import { AuthenticatedUser } from '../../../common/interfaces';
import { PaginationQueryDto } from '../../../common/dto';
import { AppConfig } from '../../../config/configuration';
import { REFRESH_COOKIE_NAME } from '../../auth/strategies/jwt-refresh.strategy';

/**
 * All routes for the owner-invitation flow (spec section 5.2/6) live under /owners/invitations:
 * create/list/cancel require authentication (GESTIONNAIRE), preview/accept are public (pre-auth
 * mobile flow), matching the split JwtAuthGuard already supports via per-route @Public().
 */
@ApiTags('owners')
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('owners/invitations')
export class OwnerInvitationsController {
  constructor(
    private readonly service: OwnerInvitationsService,
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

  @ApiBearerAuth()
  @Post()
  @Permissions('owners:invite')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreateOwnerInvitationDto) {
    return this.service.create(user.organizationId, user.id, dto);
  }

  @ApiBearerAuth()
  @Get()
  @Permissions('owners:invite', 'owners:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: PaginationQueryDto) {
    return this.service.findAll(user.id, query);
  }

  @ApiBearerAuth()
  @Post(':id/cancel')
  @Permissions('owners:invite')
  cancel(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.cancel(user.id, id);
  }

  @Public()
  @Get(':code')
  preview(@Param('code') code: string) {
    return this.service.preview(code);
  }

  @Public()
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @Post('accept')
  @HttpCode(HttpStatus.OK)
  async accept(@Body() dto: AcceptOwnerInvitationDto, @Req() req: Request, @Res({ passthrough: true }) res: Response) {
    const result = await this.service.accept(dto, { ipAddress: req.ip, userAgent: req.headers['user-agent'] });
    this.setRefreshCookie(res, result.refreshToken, result.refreshExpiresAt);
    return { accessToken: result.accessToken, user: result.user };
  }
}
