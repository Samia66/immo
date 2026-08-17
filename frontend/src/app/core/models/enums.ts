export enum RoleName {
  SUPER_ADMIN = 'SUPER_ADMIN',
  ADMIN_AGENCE = 'ADMIN_AGENCE',
  GESTIONNAIRE = 'GESTIONNAIRE',
  AGENT_IMMOBILIER = 'AGENT_IMMOBILIER',
  LOCATAIRE = 'LOCATAIRE',
}

/** Mirrors the backend's ROLE_LABELS (common/constants/permissions.constant.ts) — the auth API
 * only returns the bare `roleName` enum, not a label, so the display string is kept in sync here. */
export const ROLE_LABELS: Record<RoleName, string> = {
  [RoleName.SUPER_ADMIN]: 'Super administrateur',
  [RoleName.ADMIN_AGENCE]: "Administrateur d'agence",
  [RoleName.GESTIONNAIRE]: 'Gestionnaire',
  [RoleName.AGENT_IMMOBILIER]: 'Agent immobilier',
  [RoleName.LOCATAIRE]: 'Locataire',
};

export enum SubscriptionPlan {
  FREE = 'FREE',
  STARTER = 'STARTER',
  PROFESSIONAL = 'PROFESSIONAL',
  ENTERPRISE = 'ENTERPRISE',
}

export enum PropertyType {
  MAISON = 'MAISON',
  APPARTEMENT = 'APPARTEMENT',
  STUDIO = 'STUDIO',
  BUREAU = 'BUREAU',
  TERRAIN = 'TERRAIN',
  BOUTIQUE = 'BOUTIQUE',
}

export enum PropertyStatus {
  DISPONIBLE = 'DISPONIBLE',
  OCCUPE = 'OCCUPE',
  RESERVE = 'RESERVE',
  MAINTENANCE = 'MAINTENANCE',
}

/**
 * Mirrors the backend's 9-state lease workflow (common/constants/lease-transitions.constant.ts):
 * BROUILLON -> ENVOYE -> CONSULTE -> ACCEPTE -> ACTIF -> RESILIE, with REFUSE/ANNULE as early
 * exits and EXPIRE closing out an ACTIF lease past its end date (cron).
 */
export enum LeaseStatus {
  BROUILLON = 'BROUILLON',
  ENVOYE = 'ENVOYE',
  CONSULTE = 'CONSULTE',
  ACCEPTE = 'ACCEPTE',
  ACTIF = 'ACTIF',
  REFUSE = 'REFUSE',
  ANNULE = 'ANNULE',
  EXPIRE = 'EXPIRE',
  RESILIE = 'RESILIE',
}

export enum PaymentFrequency {
  MENSUEL = 'MENSUEL',
  TRIMESTRIEL = 'TRIMESTRIEL',
  SEMESTRIEL = 'SEMESTRIEL',
  ANNUEL = 'ANNUEL',
}

export enum PaymentStatus {
  EN_ATTENTE = 'EN_ATTENTE',
  PARTIEL = 'PARTIEL',
  PAYE = 'PAYE',
  EN_RETARD = 'EN_RETARD',
  ANNULE = 'ANNULE',
}

export enum PaymentMethod {
  ESPECES = 'ESPECES',
  VIREMENT = 'VIREMENT',
  MOBILE_MONEY = 'MOBILE_MONEY',
  CHEQUE = 'CHEQUE',
  CARTE = 'CARTE',
}

export enum ExpenseCategory {
  EAU = 'EAU',
  ELECTRICITE = 'ELECTRICITE',
  SECURITE = 'SECURITE',
  ENTRETIEN = 'ENTRETIEN',
  SYNDIC = 'SYNDIC',
  AUTRE = 'AUTRE',
}

export enum MaintenancePriority {
  BASSE = 'BASSE',
  NORMALE = 'NORMALE',
  HAUTE = 'HAUTE',
  URGENTE = 'URGENTE',
}

export enum MaintenanceStatus {
  NOUVELLE = 'NOUVELLE',
  VALIDEE = 'VALIDEE',
  ASSIGNEE = 'ASSIGNEE',
  EN_COURS = 'EN_COURS',
  TERMINEE = 'TERMINEE',
  CLOTUREE = 'CLOTUREE',
}

export enum NotificationType {
  RAPPEL_LOYER = 'RAPPEL_LOYER',
  RETARD_PAIEMENT = 'RETARD_PAIEMENT',
  CONFIRMATION_PAIEMENT = 'CONFIRMATION_PAIEMENT',
  EXPIRATION_CONTRAT = 'EXPIRATION_CONTRAT',
  MAINTENANCE = 'MAINTENANCE',
  ALERTE_ADMIN = 'ALERTE_ADMIN',
}

export enum NotificationChannel {
  IN_APP = 'IN_APP',
  EMAIL = 'EMAIL',
  SMS = 'SMS',
}
