import { BadRequestException, ConflictException, GoneException, Injectable, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../../prisma/prisma.service';
import { TenantInvitationsMapper } from './tenant-invitations.mapper';
import { ActivateTenantInvitationDto } from './dto';
import { OtpService } from '../auth/otp.service';
import { AuthService } from '../auth/auth.service';
import { TenantsService } from '../tenants/tenants.service';
import { AppConfig } from '../../config/configuration';
import { generateUniqueInvitationCode } from '../../common/utils/invitation-code.util';
import { isEmailContact, syntheticEmailForPhone } from '../../common/utils/contact.util';

const INVITATION_TTL_DAYS = 7;
const SYNTHETIC_EMAIL_DOMAIN = 'tenant.phone.local';

interface RequestMeta {
  ipAddress?: string;
  userAgent?: string;
}

@Injectable()
export class TenantInvitationsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly otpService: OtpService,
    private readonly authService: AuthService,
    private readonly tenantsService: TenantsService,
    private readonly config: ConfigService<AppConfig, true>,
  ) {}

  /** Generates a fresh PENDING invitation for a lease, revoking any previous PENDING one. */
  async createInvitation(organizationId: string, leaseId: string) {
    const lease = await this.prisma.lease.findFirst({
      where: { id: leaseId, organizationId, deletedAt: null },
    });
    if (!lease) throw new NotFoundException('Contrat introuvable.');

    await this.prisma.tenantInvitation.updateMany({
      where: { leaseId, status: 'PENDING' },
      data: { status: 'REVOKED' },
    });

    const code = await this.generateUniqueCode();
    const expiresAt = new Date(Date.now() + INVITATION_TTL_DAYS * 24 * 60 * 60 * 1000);

    const invitation = await this.prisma.tenantInvitation.create({
      data: {
        organization: { connect: { id: organizationId } },
        lease: { connect: { id: leaseId } },
        code,
        expiresAt,
      },
    });

    return TenantInvitationsMapper.toResponse(invitation, {
      leaseReference: lease.reference,
      shareMessage: `Contrat ${lease.reference} — Code d'activation : ${code}`,
    });
  }

  /** Public preview: minimal non-sensitive info only, for the "J'ai reçu une invitation" screen. */
  async preview(code: string) {
    const invitation = await this.prisma.tenantInvitation.findUnique({
      where: { code },
      include: {
        organization: { select: { name: true } },
        lease: {
          select: {
            reference: true,
            propertyUnit: {
              select: { label: true, reference: true, property: { select: { title: true } } },
            },
          },
        },
      },
    });

    if (!invitation) throw new NotFoundException('Invitation introuvable.');
    if (invitation.status !== 'PENDING') throw new GoneException("Cette invitation n'est plus valide.");
    if (invitation.expiresAt < new Date()) throw new GoneException('Cette invitation a expiré.');

    return {
      leaseReference: invitation.lease.reference,
      unitLabel: invitation.lease.propertyUnit.label ?? invitation.lease.propertyUnit.reference,
      propertyTitle: invitation.lease.propertyUnit.property.title,
      organizationName: invitation.organization.name,
      expiresAt: invitation.expiresAt,
    };
  }

  /**
   * OTP-verified tenant self-activation. Validates the invitation and OTP, creates the User
   * account (role LOCATAIRE), links it to the lease's Tenant via the SAME validation
   * TenantsService.linkUser uses (assertLinkable — see tenants.service.ts), marks the
   * invitation ACCEPTED, then logs the tenant straight in (same shape as POST /auth/login).
   *
   * Note (judgment call, see report): the User is created in its own write, then
   * `assertLinkable` + the tenant-link/invitation-accept are done in a second transaction.
   * A single all-in-one transaction isn't used here because `assertLinkable` reads through the
   * injected PrismaService's own connection — inside a still-open interactive transaction it
   * would not see the not-yet-committed User row. Splitting into two steps keeps the reused
   * validation correct at the cost of a (rare, recoverable via the existing admin link-user
   * endpoint) orphaned User if the second step fails.
   */
  async activate(code: string, dto: ActivateTenantInvitationDto, meta: RequestMeta) {
    const invitation = await this.getActivatableInvitation(code);

    const otpValid = await this.otpService.consume(dto.contact, 'ACTIVATE_TENANT', dto.otpCode);
    if (!otpValid) throw new BadRequestException('Code de vérification invalide ou expiré.');

    const isEmail = isEmailContact(dto.contact);
    const normalizedEmail = isEmail
      ? dto.contact.toLowerCase().trim()
      : syntheticEmailForPhone(dto.contact, invitation.organizationId, SYNTHETIC_EMAIL_DOMAIN);

    const locataireRole = await this.prisma.role.findFirst({
      where: { organizationId: invitation.organizationId, name: 'LOCATAIRE' },
    });
    if (!locataireRole) throw new BadRequestException('Rôle LOCATAIRE introuvable pour cette organisation.');

    const existingEmail = await this.prisma.user.findFirst({
      where: { organizationId: invitation.organizationId, email: normalizedEmail, deletedAt: null },
    });
    if (existingEmail) throw new ConflictException('Un compte existe déjà avec ces informations.');

    const passwordHash = await bcrypt.hash(dto.password, this.config.get('security.bcryptSaltRounds', { infer: true }));

    const createdUser = await this.prisma.user.create({
      data: {
        organization: { connect: { id: invitation.organizationId } },
        email: normalizedEmail,
        passwordHash,
        firstName: dto.firstName,
        lastName: dto.lastName,
        phone: !isEmail ? dto.contact : undefined,
        role: { connect: { id: locataireRole.id } },
        isActive: true,
        isEmailVerified: isEmail,
      },
    });

    await this.tenantsService.assertLinkable(invitation.lease.tenantId, createdUser.id);

    await this.prisma.$transaction([
      this.prisma.tenant.update({
        where: { id: invitation.lease.tenantId },
        data: { user: { connect: { id: createdUser.id } } },
      }),
      this.prisma.tenantInvitation.update({
        where: { id: invitation.id },
        data: { status: 'ACCEPTED', acceptedAt: new Date(), acceptedByUserId: createdUser.id },
      }),
    ]);

    const userWithRole = await this.prisma.user.findUnique({
      where: { id: createdUser.id },
      include: { role: { include: { permissions: { include: { permission: true } } } } },
    });

    // Same shape as POST /auth/login: {accessToken, refreshToken, refreshExpiresAt, user}.
    return this.authService.login(userWithRole!, meta);
  }

  private async getActivatableInvitation(code: string) {
    const invitation = await this.prisma.tenantInvitation.findUnique({
      where: { code },
      include: { lease: { select: { tenantId: true } } },
    });
    if (!invitation) throw new NotFoundException('Invitation introuvable.');
    if (invitation.status !== 'PENDING') throw new GoneException("Cette invitation n'est plus valide.");
    if (invitation.expiresAt < new Date()) throw new GoneException('Cette invitation a expiré.');
    return invitation;
  }

  private async generateUniqueCode(): Promise<string> {
    try {
      return await generateUniqueInvitationCode((candidate) =>
        this.prisma.tenantInvitation.findUnique({ where: { code: candidate } }).then(Boolean),
      );
    } catch {
      throw new ConflictException("Impossible de générer un code d'invitation unique, réessayez.");
    }
  }
}
