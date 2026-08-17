import { Logger } from '@nestjs/common';

const logger = new Logger('MailerStub');

/**
 * TODO (V2 scope, see spec §12): plug a real SMTP transport (e.g. nodemailer) here.
 * For this MVP pass we log the "sent" email instead of actually delivering it, so the
 * auth flows (verify-email, forgot-password) are fully exercised end-to-end without a
 * mail dependency.
 */
export function logStubEmail(to: string, subject: string, body: string) {
  logger.log(`[STUB EMAIL] to=${to} subject="${subject}"\n${body}`);
}

/**
 * TODO (V2 scope): plug a real SMS gateway here (e.g. Twilio, Orange/MTN mobile money-adjacent
 * SMS APIs common in the target markets). For this MVP pass we log the "sent" SMS instead of
 * actually delivering it, mirroring `logStubEmail` above, so the OTP flows (auth/otp/request,
 * invitation activation) are fully exercised end-to-end without an SMS dependency.
 */
export function logStubSms(to: string, message: string) {
  logger.log(`[STUB SMS] to=${to}\n${message}`);
}
