import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { randomUUID } from 'crypto';
import { RoleName } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { AppConfig } from '../../config/configuration';
import { ROLE_LABELS, ROLE_PERMISSIONS } from '../../common/constants/permissions.constant';
import { logStubEmail } from '../../common/utils/mailer.util';
import { RegisterDto } from './dto/register.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { AuthResponseDto, AuthUserDto } from './dto/auth-response.dto';

interface RequestMeta {
  ipAddress?: string;
  userAgent?: string;
}

const RESET_TOKEN_PURPOSE = 'reset-password';
const VERIFY_TOKEN_PURPOSE = 'verify-email';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly config: ConfigService<AppConfig, true>,
  ) {}

  // ---------------------------------------------------------------------
  // Registration (self-service org onboarding, spec §8.1)
  // ---------------------------------------------------------------------
  async register(dto: RegisterDto): Promise<AuthResponseDto> {
    // V2 pivot (spec §5.1): self-registration now creates a GESTIONNAIRE, not an ADMIN_AGENCE —
    // the mobile "Créer un compte" flow no longer assumes an agency name is the natural first
    // thing a self-registering manager types, so an empty/omitted organizationName falls back
    // to a personal default rather than being required.
    const organizationName = dto.organizationName?.trim() || `Espace de ${dto.firstName} ${dto.lastName}`;
    const code = await this.generateUniqueOrgCode(organizationName);
    const passwordHash = await bcrypt.hash(dto.password, this.config.get('security.bcryptSaltRounds', { infer: true }));

    const result = await this.prisma.$transaction(async (tx) => {
      const organization = await tx.organization.create({
        data: {
          name: organizationName,
          code,
        },
      });

      const allPermissions = await tx.permission.findMany();
      const permissionsByCode = new Map(allPermissions.map((p) => [p.code, p.id]));

      const rolesToCreate: RoleName[] = [
        'ADMIN_AGENCE',
        'GESTIONNAIRE',
        'AGENT_IMMOBILIER',
        'LOCATAIRE',
        'PROPRIETAIRE',
      ];
      const createdRoles = new Map<RoleName, string>();

      for (const roleName of rolesToCreate) {
        const role = await tx.role.create({
          data: {
            organizationId: organization.id,
            name: roleName,
            label: ROLE_LABELS[roleName],
            isSystem: true,
          },
        });
        createdRoles.set(roleName, role.id);

        const codes = ROLE_PERMISSIONS[roleName as Exclude<RoleName, 'SUPER_ADMIN'>] ?? [];
        const rolePermissionRows = codes
          .map((c) => permissionsByCode.get(c))
          .filter((id): id is string => Boolean(id))
          .map((permissionId) => ({ roleId: role.id, permissionId }));

        if (rolePermissionRows.length > 0) {
          await tx.rolePermission.createMany({ data: rolePermissionRows, skipDuplicates: true });
        }
      }

      const gestionnaireRoleId = createdRoles.get('GESTIONNAIRE') as string;

      const user = await tx.user.create({
        data: {
          organizationId: organization.id,
          email: dto.email.toLowerCase().trim(),
          passwordHash,
          firstName: dto.firstName,
          lastName: dto.lastName,
          roleId: gestionnaireRoleId,
          isEmailVerified: false,
        },
      });

      return { organization, user, roleName: RoleName.GESTIONNAIRE };
    });

    const verifyToken = this.jwt.sign(
      { sub: result.user.id, purpose: VERIFY_TOKEN_PURPOSE },
      { secret: this.config.get('jwt.accessSecret', { infer: true }), expiresIn: '24h' },
    );
    logStubEmail(
      result.user.email,
      'Vérifiez votre adresse email',
      `Bienvenue sur la plateforme. Vérifiez votre email : ${this.config.get('frontendUrl', { infer: true })}/auth/verify-email/${verifyToken}`,
    );

    const permissions = ROLE_PERMISSIONS.GESTIONNAIRE;
    const accessToken = this.signAccessToken({
      sub: result.user.id,
      organizationId: result.organization.id,
      roleId: result.user.roleId,
      roleName: RoleName.GESTIONNAIRE,
      email: result.user.email,
    });

    return {
      accessToken,
      user: this.toAuthUserDto(result.user, RoleName.GESTIONNAIRE, permissions, result.organization.id),
    };
  }

  private async generateUniqueOrgCode(name: string): Promise<string> {
    const base =
      name
        .toUpperCase()
        .normalize('NFD')
        .replace(/[̀-ͯ]/g, '')
        .replace(/[^A-Z0-9]+/g, '-')
        .replace(/(^-|-$)/g, '')
        .slice(0, 20) || 'ORG';

    let candidate = base;
    let attempt = 0;
    // eslint-disable-next-line no-constant-condition
    while (true) {
      const existing = await this.prisma.organization.findUnique({ where: { code: candidate } });
      if (!existing) return candidate;
      attempt += 1;
      candidate = `${base}-${Math.random().toString(36).slice(2, 6).toUpperCase()}`;
      if (attempt > 10) {
        candidate = `${base}-${Date.now()}`;
      }
    }
  }

  // ---------------------------------------------------------------------
  // Login / credential validation (spec §14.1: bcrypt, account lockout)
  // ---------------------------------------------------------------------
  async validateUser(email: string, password: string) {
    const normalizedEmail = email.toLowerCase().trim();
    // NOTE: email uniqueness is enforced per-organization (@@unique([organizationId, email])),
    // not globally. LoginDto (per spec §6.1) only carries an email, so we resolve the first
    // matching active account across organizations. A real multi-org-per-email deployment
    // would need an organization selector on the login form; documented as a known MVP
    // simplification.
    const user = await this.prisma.user.findFirst({
      where: { email: normalizedEmail, deletedAt: null },
      include: { role: { include: { permissions: { include: { permission: true } } } } },
    });

    if (!user) {
      throw new UnauthorizedException('Identifiants invalides.');
    }

    if (user.lockedUntil && user.lockedUntil > new Date()) {
      throw new ForbiddenException(
        `Compte temporairement verrouillé suite à trop de tentatives échouées. Réessayez après ${user.lockedUntil.toISOString()}.`,
      );
    }

    if (!user.isActive) {
      throw new ForbiddenException('Compte désactivé.');
    }

    const passwordValid = await bcrypt.compare(password, user.passwordHash);
    const maxAttempts = this.config.get('security.loginMaxAttempts', { infer: true });
    const lockMinutes = this.config.get('security.loginLockMinutes', { infer: true });

    if (!passwordValid) {
      const failedLoginCount = user.failedLoginCount + 1;
      const lockedUntil = failedLoginCount >= maxAttempts ? new Date(Date.now() + lockMinutes * 60_000) : null;
      await this.prisma.user.update({
        where: { id: user.id },
        data: { failedLoginCount, lockedUntil },
      });
      throw new UnauthorizedException('Identifiants invalides.');
    }

    if (user.failedLoginCount > 0 || user.lockedUntil) {
      await this.prisma.user.update({
        where: { id: user.id },
        data: { failedLoginCount: 0, lockedUntil: null },
      });
    }

    return user;
  }

  async login(user: Awaited<ReturnType<AuthService['validateUser']>>, meta: RequestMeta) {
    await this.prisma.user.update({ where: { id: user.id }, data: { lastLoginAt: new Date() } });
    await this.prisma.auditLog.create({
      data: {
        organizationId: user.organizationId,
        userId: user.id,
        action: 'LOGIN',
        entity: 'User',
        entityId: user.id,
        ipAddress: meta.ipAddress,
      },
    });

    const permissions = user.role.permissions.map((rp) => rp.permission.code);
    const accessToken = this.signAccessToken({
      sub: user.id,
      organizationId: user.organizationId,
      roleId: user.roleId,
      roleName: user.role.name,
      email: user.email,
    });
    const { rawRefreshToken, expiresAt } = await this.createRefreshToken(user.id, meta);

    return {
      accessToken,
      refreshToken: rawRefreshToken,
      refreshExpiresAt: expiresAt,
      user: this.toAuthUserDto(user, user.role.name, permissions, user.organizationId),
    };
  }

  // ---------------------------------------------------------------------
  // Refresh token rotation + theft detection (spec §14.1)
  // ---------------------------------------------------------------------
  private async createRefreshToken(userId: string, meta: RequestMeta) {
    const refreshExpiresIn = this.config.get('jwt.refreshExpiresIn', { infer: true });
    const expiresAt = this.addDuration(new Date(), refreshExpiresIn);
    const tokenId = randomUUID();

    const rawRefreshToken = this.jwt.sign(
      { sub: userId, tokenId },
      {
        secret: this.config.get('jwt.refreshSecret', { infer: true }),
        expiresIn: refreshExpiresIn as unknown as number,
      },
    );

    const tokenHash = await bcrypt.hash(rawRefreshToken, 10);

    await this.prisma.refreshToken.create({
      data: {
        id: tokenId,
        userId,
        tokenHash,
        userAgent: meta.userAgent,
        ipAddress: meta.ipAddress,
        expiresAt,
      },
    });

    return { rawRefreshToken, expiresAt };
  }

  async refreshTokens(payload: { sub: string; tokenId: string; rawToken: string | null }, meta: RequestMeta) {
    if (!payload.rawToken) {
      throw new UnauthorizedException('Refresh token manquant.');
    }

    const stored = await this.prisma.refreshToken.findUnique({ where: { id: payload.tokenId } });

    if (!stored || stored.userId !== payload.sub) {
      throw new UnauthorizedException('Refresh token invalide.');
    }

    if (stored.revokedAt || stored.expiresAt < new Date()) {
      // Reuse of a revoked/expired token is a strong signal of token theft: revoke the
      // entire token family for this user as a precaution.
      await this.revokeAllUserTokens(payload.sub);
      throw new UnauthorizedException(
        'Refresh token expiré ou révoqué. Toutes les sessions ont été déconnectées par sécurité.',
      );
    }

    const matches = await bcrypt.compare(payload.rawToken, stored.tokenHash);
    if (!matches) {
      await this.revokeAllUserTokens(payload.sub);
      throw new UnauthorizedException('Refresh token invalide. Toutes les sessions ont été déconnectées par sécurité.');
    }

    const user = await this.prisma.user.findUnique({
      where: { id: payload.sub },
      include: { role: { include: { permissions: { include: { permission: true } } } } },
    });

    if (!user || user.deletedAt || !user.isActive) {
      throw new UnauthorizedException('Compte utilisateur introuvable ou désactivé.');
    }

    // Rotate: revoke the old token, mint a new one.
    await this.prisma.refreshToken.update({ where: { id: stored.id }, data: { revokedAt: new Date() } });
    const { rawRefreshToken, expiresAt } = await this.createRefreshToken(user.id, meta);

    const permissions = user.role.permissions.map((rp) => rp.permission.code);
    const accessToken = this.signAccessToken({
      sub: user.id,
      organizationId: user.organizationId,
      roleId: user.roleId,
      roleName: user.role.name,
      email: user.email,
    });

    return {
      accessToken,
      refreshToken: rawRefreshToken,
      refreshExpiresAt: expiresAt,
      user: this.toAuthUserDto(user, user.role.name, permissions, user.organizationId),
    };
  }

  private async revokeAllUserTokens(userId: string) {
    await this.prisma.refreshToken.updateMany({
      where: { userId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }

  async logout(userId: string, tokenId: string | undefined) {
    if (tokenId) {
      await this.prisma.refreshToken.updateMany({
        where: { id: tokenId, userId, revokedAt: null },
        data: { revokedAt: new Date() },
      });
    }
    await this.prisma.auditLog.create({
      data: { userId, action: 'LOGOUT', entity: 'User', entityId: userId },
    });
    return { success: true };
  }

  // ---------------------------------------------------------------------
  // Password reset / email verification (stubs log instead of sending, see mailer.util.ts)
  // ---------------------------------------------------------------------
  async forgotPassword(email: string) {
    const user = await this.prisma.user.findFirst({ where: { email: email.toLowerCase().trim(), deletedAt: null } });
    // Always respond generically to avoid leaking account existence.
    if (!user) {
      this.logger.warn(`Password reset requested for unknown email: ${email}`);
      return { success: true };
    }

    const token = this.jwt.sign(
      { sub: user.id, purpose: RESET_TOKEN_PURPOSE },
      { secret: this.config.get('jwt.accessSecret', { infer: true }), expiresIn: '1h' },
    );

    logStubEmail(
      user.email,
      'Réinitialisation de votre mot de passe',
      `Réinitialisez votre mot de passe : ${this.config.get('frontendUrl', { infer: true })}/auth/reset-password/${token}`,
    );

    return { success: true };
  }

  async resetPassword(dto: ResetPasswordDto) {
    let payload: { sub: string; purpose: string };
    try {
      payload = this.jwt.verify(dto.token, { secret: this.config.get('jwt.accessSecret', { infer: true }) });
    } catch {
      throw new BadRequestException('Lien de réinitialisation invalide ou expiré.');
    }

    if (payload.purpose !== RESET_TOKEN_PURPOSE) {
      throw new BadRequestException('Jeton invalide.');
    }

    const passwordHash = await bcrypt.hash(
      dto.newPassword,
      this.config.get('security.bcryptSaltRounds', { infer: true }),
    );

    await this.prisma.user.update({
      where: { id: payload.sub },
      data: { passwordHash, failedLoginCount: 0, lockedUntil: null },
    });
    await this.revokeAllUserTokens(payload.sub);

    return { success: true };
  }

  async verifyEmail(token: string) {
    let payload: { sub: string; purpose: string };
    try {
      payload = this.jwt.verify(token, { secret: this.config.get('jwt.accessSecret', { infer: true }) });
    } catch {
      throw new BadRequestException('Lien de vérification invalide ou expiré.');
    }

    if (payload.purpose !== VERIFY_TOKEN_PURPOSE) {
      throw new BadRequestException('Jeton invalide.');
    }

    await this.prisma.user.update({ where: { id: payload.sub }, data: { isEmailVerified: true } });
    return { success: true };
  }

  async changePassword(userId: string, dto: ChangePasswordDto) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundException('Utilisateur introuvable.');

    const matches = await bcrypt.compare(dto.currentPassword, user.passwordHash);
    if (!matches) throw new UnauthorizedException('Mot de passe actuel incorrect.');

    const passwordHash = await bcrypt.hash(
      dto.newPassword,
      this.config.get('security.bcryptSaltRounds', { infer: true }),
    );
    await this.prisma.user.update({ where: { id: userId }, data: { passwordHash } });
    await this.revokeAllUserTokens(userId);

    return { success: true };
  }

  async me(userId: string): Promise<AuthUserDto> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: { role: { include: { permissions: { include: { permission: true } } } } },
    });
    if (!user) throw new NotFoundException('Utilisateur introuvable.');
    const permissions = user.role.permissions.map((rp) => rp.permission.code);
    return this.toAuthUserDto(user, user.role.name, permissions, user.organizationId);
  }

  // ---------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------
  private signAccessToken(payload: {
    sub: string;
    organizationId: string;
    roleId: string;
    roleName: RoleName;
    email: string;
  }): string {
    return this.jwt.sign(payload, {
      secret: this.config.get('jwt.accessSecret', { infer: true }),
      expiresIn: this.config.get('jwt.accessExpiresIn', { infer: true }),
    });
  }

  private toAuthUserDto(
    user: { id: string; email: string; firstName: string; lastName: string; isEmailVerified: boolean },
    roleName: RoleName,
    permissions: string[],
    organizationId: string,
  ): AuthUserDto {
    return {
      id: user.id,
      organizationId,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      roleName,
      permissions,
      isEmailVerified: user.isEmailVerified,
    };
  }

  private addDuration(base: Date, duration: string): Date {
    const match = /^(\d+)([smhd])$/.exec(duration.trim());
    if (!match) return new Date(base.getTime() + 30 * 24 * 60 * 60 * 1000);
    const value = parseInt(match[1], 10);
    const unit = match[2];
    const unitMs = { s: 1000, m: 60_000, h: 3_600_000, d: 86_400_000 }[unit] ?? 86_400_000;
    return new Date(base.getTime() + value * unitMs);
  }
}
