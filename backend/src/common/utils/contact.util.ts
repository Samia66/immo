/** Simple heuristic (per spec Part C): anything without an "@" is treated as a phone number. */
export function isEmailContact(contact: string): boolean {
  return contact.includes('@');
}

/**
 * User.email is required + unique-per-org (see schema) but invitation-acceptance flows allow a
 * raw phone `contact`, so phone-only activations get a deterministic synthetic placeholder email
 * instead — the real contact is preserved in User.phone. `domain` lets callers keep the tenant-
 * and owner-activation email spaces separate (a phone number could otherwise collide between the
 * two role flows within the same org).
 */
export function syntheticEmailForPhone(phone: string, organizationId: string, domain: string): string {
  const digits = phone.replace(/\D/g, '');
  return `${digits}+${organizationId.slice(0, 8)}@${domain}`;
}
