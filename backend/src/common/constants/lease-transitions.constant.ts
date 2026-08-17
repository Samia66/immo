import { LeaseStatus } from '@prisma/client';

/**
 * Lease workflow (spec Part B): a draft contract is prepared, sent to the tenant, optionally
 * marked as consulted, then accepted (which cascades straight into ACTIF — see leases.service.ts
 * `accept()`), or refused/cancelled along the way. ACTIF/RESILIE/EXPIRE close out the lifecycle.
 *
 *   BROUILLON -> ENVOYE -> CONSULTE -> ACCEPTE -> ACTIF -> RESILIE
 *                  \          \          /                    ^
 *                   \          -> REFUSE                 EXPIRE (cron)
 *                    -> ANNULE
 */
export const LEASE_TRANSITIONS: Record<LeaseStatus, LeaseStatus[]> = {
  BROUILLON: ['ENVOYE', 'ANNULE'],
  ENVOYE: ['CONSULTE', 'ACCEPTE', 'REFUSE', 'ANNULE'],
  CONSULTE: ['ACCEPTE', 'REFUSE', 'ANNULE'],
  ACCEPTE: ['ACTIF'],
  ACTIF: ['RESILIE', 'EXPIRE'],
  REFUSE: [],
  ANNULE: [],
  EXPIRE: [],
  RESILIE: [],
};

export function isLeaseTransitionAllowed(from: LeaseStatus, to: LeaseStatus): boolean {
  return LEASE_TRANSITIONS[from]?.includes(to) ?? false;
}

/**
 * Statuses that represent a lease still "in play" for a unit: an ACTIF lease occupies the unit,
 * while ACCEPTE/ENVOYE/CONSULTE represent an in-flight offer that should block a second
 * concurrent lease from being created on/deleting the same unit. BROUILLON is deliberately
 * excluded — an unsent draft doesn't reserve the unit.
 */
export const NON_TERMINAL_LEASE_STATUSES: LeaseStatus[] = ['ACTIF', 'ACCEPTE', 'ENVOYE', 'CONSULTE'];
