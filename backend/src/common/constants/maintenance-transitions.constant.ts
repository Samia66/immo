import { MaintenanceStatus } from '@prisma/client';

/**
 * Explicit allowed-transitions map for the maintenance workflow (spec §8.4):
 * NOUVELLE -> VALIDEE -> ASSIGNEE -> EN_COURS -> TERMINEE -> CLOTUREE
 *
 * Backward transitions are forbidden for everyone except ADMIN_AGENCE, who may force a
 * transition back to any of the immediately preceding states (typically to correct a mistake).
 */
export const MAINTENANCE_FORWARD_TRANSITIONS: Record<MaintenanceStatus, MaintenanceStatus[]> = {
  NOUVELLE: [MaintenanceStatus.VALIDEE],
  VALIDEE: [MaintenanceStatus.ASSIGNEE],
  ASSIGNEE: [MaintenanceStatus.EN_COURS],
  EN_COURS: [MaintenanceStatus.TERMINEE],
  TERMINEE: [MaintenanceStatus.CLOTUREE],
  CLOTUREE: [],
};

export const MAINTENANCE_STATUS_ORDER: MaintenanceStatus[] = [
  MaintenanceStatus.NOUVELLE,
  MaintenanceStatus.VALIDEE,
  MaintenanceStatus.ASSIGNEE,
  MaintenanceStatus.EN_COURS,
  MaintenanceStatus.TERMINEE,
  MaintenanceStatus.CLOTUREE,
];

export function isForwardTransitionAllowed(from: MaintenanceStatus, to: MaintenanceStatus): boolean {
  return MAINTENANCE_FORWARD_TRANSITIONS[from]?.includes(to) ?? false;
}

export function isBackwardTransition(from: MaintenanceStatus, to: MaintenanceStatus): boolean {
  return MAINTENANCE_STATUS_ORDER.indexOf(to) < MAINTENANCE_STATUS_ORDER.indexOf(from);
}
