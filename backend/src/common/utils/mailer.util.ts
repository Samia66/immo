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
