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

const smsLogger = new Logger('SmsService');

// MTN Developer Portal ("SMS API v1", https://developers.mtn.com) — OAuth2 client_credentials
// token exchange, then a bearer-authenticated POST to send the message. Implemented from
// publicly indexed API descriptions, NOT a directly-fetched copy of MTN's current docs
// (developers.mtn.com is unreachable from this build environment) — if the first real call
// 400s, check the response body and adjust the request field names below accordingly.
const MTN_TOKEN_URL = 'https://api.mtn.com/oauth/client_credential/accesstoken?grant_type=client_credentials';
const MTN_SMS_URL = 'https://api.mtn.com/v1/messages/sms';

let cachedMtnToken: { value: string; expiresAt: number } | null = null;

async function getMtnAccessToken(consumerKey: string, consumerSecret: string): Promise<string | null> {
  // Reuse the cached token until 30s before its actual expiry, to avoid a token round-trip on
  // every single SMS (MTN access tokens are typically valid ~1h).
  if (cachedMtnToken && cachedMtnToken.expiresAt > Date.now() + 30_000) {
    return cachedMtnToken.value;
  }

  try {
    const response = await fetch(MTN_TOKEN_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        Authorization: `Basic ${Buffer.from(`${consumerKey}:${consumerSecret}`).toString('base64')}`,
      },
    });

    if (!response.ok) {
      smsLogger.error(`Échec récupération token MTN: ${response.status} ${await response.text()}`);
      return null;
    }

    const data = (await response.json()) as { access_token: string; expires_in?: string | number };
    const expiresInMs = (Number(data.expires_in) || 3600) * 1000;
    cachedMtnToken = { value: data.access_token, expiresAt: Date.now() + expiresInMs };
    return cachedMtnToken.value;
  } catch (error) {
    smsLogger.error(`Erreur réseau lors de la récupération du token MTN: ${(error as Error).message}`);
    return null;
  }
}

/**
 * Sends an SMS via the MTN Developer Portal when MTN_CONSUMER_KEY / MTN_CONSUMER_SECRET /
 * MTN_SENDER_ADDRESS are all configured; otherwise falls back to logging the message like the
 * old stub did, so local dev without MTN credentials keeps working unchanged. Delivery failures
 * are logged, not thrown: the OTP code itself is already persisted and independently verifiable
 * via `POST /auth/otp/verify` by the time this runs, so a transport error here must not fail
 * the request that triggered it.
 */
export async function sendSms(to: string, message: string): Promise<void> {
  const { MTN_CONSUMER_KEY, MTN_CONSUMER_SECRET, MTN_SENDER_ADDRESS } = process.env;

  if (!MTN_CONSUMER_KEY || !MTN_CONSUMER_SECRET || !MTN_SENDER_ADDRESS) {
    smsLogger.log(`[STUB SMS — MTN non configuré] to=${to}\n${message}`);
    return;
  }

  const token = await getMtnAccessToken(MTN_CONSUMER_KEY, MTN_CONSUMER_SECRET);
  if (!token) {
    smsLogger.error(`SMS non envoyé (pas de token MTN valide) à ${to}`);
    return;
  }

  try {
    const response = await fetch(MTN_SMS_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        senderAddress: MTN_SENDER_ADDRESS,
        recipientAddress: [to],
        message,
      }),
    });

    if (!response.ok) {
      smsLogger.error(`Échec de l'envoi SMS MTN à ${to}: ${response.status} ${await response.text()}`);
      return;
    }

    smsLogger.log(`SMS envoyé via MTN à ${to}`);
  } catch (error) {
    smsLogger.error(`Erreur réseau lors de l'envoi SMS MTN à ${to}: ${(error as Error).message}`);
  }
}
