import { randomInt } from 'crypto';

const CODE_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // no ambiguous chars (0/O, 1/I/L)
const CODE_LENGTH = 5;

/** Shared "IMMO-XXXXX" code generator, used by both the tenant- and owner-invitation flows. */
export function generateInvitationCode(): string {
  let code = '';
  for (let i = 0; i < CODE_LENGTH; i++) {
    code += CODE_ALPHABET[randomInt(0, CODE_ALPHABET.length)];
  }
  return `IMMO-${code}`;
}

/**
 * Generates a code and retries (up to 10x) until `exists` reports it unused. Throws
 * UNIQUE_CODE_GENERATION_FAILED on exhaustion — callers should catch it and raise their own
 * domain-appropriate exception (e.g. ConflictException) with a localized message.
 */
export async function generateUniqueInvitationCode(exists: (code: string) => Promise<boolean>): Promise<string> {
  for (let attempt = 0; attempt < 10; attempt++) {
    const candidate = generateInvitationCode();
    if (!(await exists(candidate))) return candidate;
  }
  throw new Error('UNIQUE_CODE_GENERATION_FAILED');
}
