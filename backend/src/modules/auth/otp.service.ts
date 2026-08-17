import { Injectable } from '@nestjs/common';
import { randomInt } from 'crypto';
import { OtpPurpose } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { logStubEmail, sendSms } from '../../common/utils/mailer.util';

const OTP_TTL_MINUTES = 10;
const MAX_ATTEMPTS = 5;

/** Simple heuristic (per spec Part C): anything without an "@" is treated as a phone number. */
function looksLikePhone(contact: string): boolean {
  return !contact.includes('@');
}

/**
 * Generates, delivers (via the SMS/email stubs) and validates one-time codes for pre-auth flows:
 * tenant self-activation (InvitationsService) and any future OTP-gated flow. Used by both
 * AuthController (request/verify) and InvitationsService (consume, inside `/activate`).
 */
@Injectable()
export class OtpService {
  constructor(private readonly prisma: PrismaService) {}

  async request(contact: string, purpose: OtpPurpose) {
    const code = randomInt(0, 1_000_000).toString().padStart(6, '0');
    const expiresAt = new Date(Date.now() + OTP_TTL_MINUTES * 60_000);

    await this.prisma.otpCode.create({ data: { contact, code, purpose, expiresAt } });

    const message = `Votre code de vérification est : ${code} (valide ${OTP_TTL_MINUTES} minutes).`;
    if (looksLikePhone(contact)) {
      await sendSms(contact, message);
    } else {
      logStubEmail(contact, 'Votre code de vérification', message);
    }

    return { success: true };
  }

  /** Dry-run check (never mutates state) — lets the mobile app validate a code before final submission. */
  async verify(contact: string, purpose: OtpPurpose, code: string): Promise<boolean> {
    const otp = await this.findActive(contact, purpose);
    return otp?.code === code;
  }

  /**
   * Consumes a matching OTP: increments `attempts` on mismatch, marks `consumedAt` on success.
   * This is the real gate used by `POST /invitations/:code/activate` — `verify()` above never
   * mutates state and must not be relied on to actually gate account creation.
   */
  async consume(contact: string, purpose: OtpPurpose, code: string): Promise<boolean> {
    const otp = await this.findActive(contact, purpose);
    if (!otp) return false;

    if (otp.code !== code) {
      await this.prisma.otpCode.update({ where: { id: otp.id }, data: { attempts: { increment: 1 } } });
      return false;
    }

    await this.prisma.otpCode.update({ where: { id: otp.id }, data: { consumedAt: new Date() } });
    return true;
  }

  private findActive(contact: string, purpose: OtpPurpose) {
    return this.prisma.otpCode.findFirst({
      where: { contact, purpose, consumedAt: null, attempts: { lt: MAX_ATTEMPTS }, expiresAt: { gt: new Date() } },
      orderBy: { createdAt: 'desc' },
    });
  }
}
