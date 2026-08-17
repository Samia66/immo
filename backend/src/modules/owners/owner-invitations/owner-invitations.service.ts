import { BadRequestException, ConflictException, GoneException, Injectable, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../../prisma/prisma.service';
import { OwnerInvitationsMapper } from './owner-invitations.mapper';
import { CreateOwnerInvitationDto, AcceptOwnerInvitationDto } from './dto';
import { OtpService } from '../../auth/otp.service';
import { AuthService } from '../../auth/auth.service';
import { AppConfig } from '../../../config/configuration';
import { PaginatedResponseDto, PaginationQueryDto } from '../../../common/dto';
import { generateUniqueInvitationCode } from '../../../common/utils/invitation-code.util';
import { isEmailContact, syntheticEmailForPhone } from '../../../common/utils/contact.util';

const INVITATION_TTL_DAYS = 7;
const SYNTHETIC_EMAIL_DOMAIN = 'owner.phone.local';

interface RequestMeta {
  ipAddress?: string;
  userAgent?: string;
}

@Injectable()
export class OwnerInvitationsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly otpService: OtpService,
    private readonly authService: AuthService,
    private readonly config: ConfigService<AppConfig, true>,
  ) {}

  /** GESTIONNAIRE, "Mes propriétaires" -> "+ Inviter". */
  async create(organizationId: string, managerId: string, dto: CreateOwnerInvitationDto) {
    const code = await this.generateUniqueCode();
    const expiresAt = new Date(Date.now() + INVITATION_TTL_DAYS * 24 * 60 * 60 * 1000);

    const invitation = await this.prisma.ownerInvitation.create({
      data: {
        organization: { connect: { id: organizationId } },
        manager: { connect: { id: managerId } },
        firstName: dto.firstName,
        lastName: dto.lastName,
        email: dto.email,
        phone: dto.phone,
        code,
        expiresAt,
      },
    });

    return OwnerInvitationsMapper.toResponse(invitation, {
      shareMessage: `Invitation propriétaire ImmoSaaS — Code d'activation : ${code}`,
    });
  }

  /** The manager's own sent invitations, paginated. */
  async findAll(managerId: string, query: PaginationQueryDto) {
    const where: Prisma.OwnerInvitationWhereInput = { managerId };

    const [items, total] = await Promise.all([
      this.prisma.ownerInvitation.findMany({
        where,
        skip: (query.page - 1) * query.limit,
        take: query.limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.ownerInvitation.count({ where }),
    ]);

    return new PaginatedResponseDto(
      items.map((i) => OwnerInvitationsMapper.toResponse(i)),
      total,
      query.page,
      query.limit,
    );
  }

  /** Manager-owned only: cancels one of their own PENDING invitations. */
  async cancel(managerId: string, id: string) {
    const invitation = await this.prisma.ownerInvitation.findFirst({ where: { id, managerId } });
    if (!invitation) throw new NotFoundException('Invitation introuvable.');
    if (invitation.status !== 'PENDING') {
      throw new ConflictException('Seule une invitation en attente peut être annulée.');
    }

    const updated = await this.prisma.ownerInvitation.update({ where: { id }, data: { status: 'CANCELLED' } });
    return OwnerInvitationsMapper.toResponse(updated);
  }

  /** Public preview: minimal non-sensitive info only, for the "J'ai reçu une invitation" screen. */
  async preview(code: string) {
    const invitation = await this.prisma.ownerInvitation.findUnique({
      where: { code },
      include: {
        organization: { select: { name: true } },
        manager: { select: { firstName: true, lastName: true } },
      },
    });

    if (!invitation) throw new NotFoundException('Invitation introuvable.');
    if (invitation.status !== 'PENDING') throw new GoneException("Cette invitation n'est plus valide.");
    if (invitation.expiresAt < new Date()) throw new GoneException('Cette invitation a expiré.');

    return {
      managerFirstName: invitation.manager.firstName,
      managerLastName: invitation.manager.lastName,
      organizationName: invitation.organization.name,
      expiresAt: invitation.expiresAt,
    };
  }

  /**
   * OTP-verified owner self-registration. Validates the invitation and OTP, then in a single
   * transaction: creates the User (role PROPRIETAIRE), finds-or-creates the matching Owner record
   * for this org (same-org lookup-by-email/phone, mirroring TenantsService.create()'s pattern —
   * see findOrCreateOwner below), links Owner.userId, upserts an ACTIVE ManagerOwner row, and
   * marks the invitation ACCEPTED. Logs the new owner straight in (same shape as POST /auth/login).
   */
  async accept(dto: AcceptOwnerInvitationDto, meta: RequestMeta) {
    const invitation = await this.getActivatableInvitation(dto.code);

    const otpValid = await this.otpService.consume(dto.contact, 'REGISTER_OWNER', dto.otpCode);
    if (!otpValid) throw new BadRequestException('Code de vérification invalide ou expiré.');

    const isEmail = isEmailContact(dto.contact);
    const normalizedEmail = isEmail
      ? dto.contact.toLowerCase().trim()
      : syntheticEmailForPhone(dto.contact, invitation.organizationId, SYNTHETIC_EMAIL_DOMAIN);
    const phone = !isEmail ? dto.contact : (invitation.phone ?? undefined);
    const email = isEmail ? normalizedEmail : (invitation.email ?? undefined);

    const proprietaireRole = await this.prisma.role.findFirst({
      where: { organizationId: invitation.organizationId, name: 'PROPRIETAIRE' },
    });
    if (!proprietaireRole) throw new BadRequestException('Rôle PROPRIETAIRE introuvable pour cette organisation.');

    const existingUser = await this.prisma.user.findFirst({
      where: { organizationId: invitation.organizationId, email: normalizedEmail, deletedAt: null },
    });
    if (existingUser) throw new ConflictException('Un compte existe déjà avec ces informations.');

    // Owner.phone is a mandatory column (schema reused as-is, see report) — a phone must be
    // resolvable from either the verified contact or the invitation to create a fresh Owner.
    if (!phone) {
      const existingOwner = await this.findMatchingOwner(invitation.organizationId, email, undefined);
      if (!existingOwner?.phone) {
        throw new BadRequestException(
          "Un numéro de téléphone est requis (via le contact vérifié ou l'invitation) pour finaliser l'inscription.",
        );
      }
    }

    const passwordHash = await bcrypt.hash(dto.password, this.config.get('security.bcryptSaltRounds', { infer: true }));

    const createdUser = await this.prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: {
          organization: { connect: { id: invitation.organizationId } },
          email: normalizedEmail,
          passwordHash,
          firstName: dto.firstName,
          lastName: dto.lastName,
          phone: !isEmail ? dto.contact : undefined,
          role: { connect: { id: proprietaireRole.id } },
          isActive: true,
          isEmailVerified: isEmail,
        },
      });

      let owner = await this.findMatchingOwner(invitation.organizationId, email, phone, tx);

      if (owner) {
        if (owner.userId && owner.userId !== user.id) {
          throw new ConflictException(
            'Ce propriétaire est déjà lié à un autre compte utilisateur. Contactez le support.',
          );
        }
        owner = await tx.owner.update({ where: { id: owner.id }, data: { userId: user.id } });
      } else {
        owner = await tx.owner.create({
          data: {
            organization: { connect: { id: invitation.organizationId } },
            user: { connect: { id: user.id } },
            fullName: `${dto.firstName} ${dto.lastName}`.trim(),
            phone: phone as string,
            email: email ?? null,
          },
        });
      }

      await tx.managerOwner.upsert({
        where: { managerId_ownerId: { managerId: invitation.managerId, ownerId: owner.id } },
        update: { status: 'ACTIVE', endDate: null },
        create: {
          organization: { connect: { id: invitation.organizationId } },
          manager: { connect: { id: invitation.managerId } },
          owner: { connect: { id: owner.id } },
          status: 'ACTIVE',
        },
      });

      await tx.ownerInvitation.update({
        where: { id: invitation.id },
        data: { status: 'ACCEPTED', acceptedAt: new Date(), ownerId: owner.id },
      });

      return user;
    });

    const userWithRole = await this.prisma.user.findUnique({
      where: { id: createdUser.id },
      include: { role: { include: { permissions: { include: { permission: true } } } } },
    });

    // Same shape as POST /auth/login: {accessToken, refreshToken, refreshExpiresAt, user}.
    return this.authService.login(userWithRole!, meta);
  }

  private async getActivatableInvitation(code: string) {
    const invitation = await this.prisma.ownerInvitation.findUnique({ where: { code } });
    if (!invitation) throw new NotFoundException('Invitation introuvable.');
    if (invitation.status !== 'PENDING') throw new GoneException("Cette invitation n'est plus valide.");
    if (invitation.expiresAt < new Date()) throw new GoneException('Cette invitation a expiré.');
    return invitation;
  }

  /** Same-org lookup-by-email/phone, mirroring TenantsService.create()'s existing-account pattern. */
  private findMatchingOwner(
    organizationId: string,
    email: string | undefined,
    phone: string | undefined,
    tx: Prisma.TransactionClient | PrismaService = this.prisma,
  ) {
    const orConditions: Prisma.OwnerWhereInput[] = [];
    if (email) orConditions.push({ email: { equals: email, mode: 'insensitive' } });
    if (phone) orConditions.push({ phone });
    if (orConditions.length === 0) return Promise.resolve(null);

    return tx.owner.findFirst({ where: { organizationId, deletedAt: null, OR: orConditions } });
  }

  private async generateUniqueCode(): Promise<string> {
    try {
      return await generateUniqueInvitationCode((candidate) =>
        this.prisma.ownerInvitation.findUnique({ where: { code: candidate } }).then(Boolean),
      );
    } catch {
      throw new ConflictException("Impossible de générer un code d'invitation unique, réessayez.");
    }
  }
}
