import { RoleName } from '@prisma/client';

export interface PermissionDefinition {
  code: string;
  module: string;
  description: string;
}

/**
 * Canonical list of permission codes ("<module>:<action>"), seeded as `Permission` rows and
 * referenced by @Permissions(...) decorators across controllers. Keeping this list centralized
 * avoids typos causing silent access-control drift between the guard metadata and the seed.
 */
export const PERMISSIONS: PermissionDefinition[] = [
  // organizations
  {
    code: 'organizations:read_all',
    module: 'organizations',
    description: 'Lister toutes les organisations (SUPER_ADMIN)',
  },
  { code: 'organizations:create', module: 'organizations', description: 'Créer une organisation' },
  { code: 'organizations:update', module: 'organizations', description: 'Modifier une organisation (globale)' },
  { code: 'organizations:manage_subscription', module: 'organizations', description: "Changer le plan d'abonnement" },
  { code: 'organizations:toggle_active', module: 'organizations', description: 'Activer/désactiver une organisation' },
  { code: 'organizations:read_own', module: 'organizations', description: 'Lire sa propre organisation' },
  { code: 'organizations:update_own', module: 'organizations', description: 'Modifier sa propre organisation' },

  // users
  { code: 'users:read', module: 'users', description: 'Lister/consulter les utilisateurs' },
  { code: 'users:create', module: 'users', description: 'Créer un utilisateur' },
  { code: 'users:update', module: 'users', description: 'Modifier un utilisateur' },
  { code: 'users:change_role', module: 'users', description: "Changer le rôle d'un utilisateur" },
  { code: 'users:toggle_active', module: 'users', description: 'Activer/désactiver un utilisateur' },
  { code: 'users:delete', module: 'users', description: 'Supprimer (soft) un utilisateur' },
  { code: 'users:upload_avatar', module: 'users', description: "Uploader l'avatar de tout utilisateur" },

  // roles & permissions
  { code: 'roles:read', module: 'roles', description: 'Lister les rôles' },
  { code: 'roles:create', module: 'roles', description: 'Créer un rôle personnalisé' },
  { code: 'roles:update_permissions', module: 'roles', description: "Modifier les permissions d'un rôle" },
  { code: 'permissions:read', module: 'permissions', description: 'Lister les permissions disponibles' },

  // properties
  { code: 'properties:read', module: 'properties', description: 'Lire les biens' },
  { code: 'properties:create', module: 'properties', description: 'Créer un bien' },
  { code: 'properties:update', module: 'properties', description: 'Modifier un bien' },
  { code: 'properties:delete', module: 'properties', description: 'Supprimer (soft) un bien' },
  { code: 'properties:manage_images', module: 'properties', description: 'Gérer les photos du bien' },
  { code: 'properties:read_history', module: 'properties', description: "Consulter l'historique du bien" },
  { code: 'properties:read_own', module: 'properties', description: 'Consulter ses propres biens (propriétaire)' },

  // owners
  { code: 'owners:read', module: 'owners', description: 'Lire les propriétaires' },
  { code: 'owners:create', module: 'owners', description: 'Créer un propriétaire' },
  { code: 'owners:update', module: 'owners', description: 'Modifier un propriétaire' },
  { code: 'owners:delete', module: 'owners', description: 'Supprimer (soft) un propriétaire' },
  { code: 'owners:invite', module: 'owners', description: 'Inviter un propriétaire (auto-inscription liée)' },

  // tenants
  { code: 'tenants:read', module: 'tenants', description: 'Lister les locataires' },
  { code: 'tenants:read_detail', module: 'tenants', description: 'Consulter le détail/historique locatif' },
  { code: 'tenants:create', module: 'tenants', description: 'Créer un locataire' },
  { code: 'tenants:update', module: 'tenants', description: 'Modifier un locataire' },
  { code: 'tenants:manage_documents', module: 'tenants', description: 'Gérer les documents locataire' },
  { code: 'tenants:delete', module: 'tenants', description: 'Supprimer (soft) un locataire' },

  // leases
  { code: 'leases:read', module: 'leases', description: 'Lister les contrats' },
  { code: 'leases:read_detail', module: 'leases', description: "Consulter le détail d'un contrat" },
  { code: 'leases:create', module: 'leases', description: 'Créer un contrat' },
  { code: 'leases:update', module: 'leases', description: 'Modifier un contrat' },
  { code: 'leases:renew', module: 'leases', description: 'Renouveler un contrat' },
  { code: 'leases:terminate', module: 'leases', description: 'Résilier un contrat' },
  { code: 'leases:manage_amendments', module: 'leases', description: 'Ajouter un avenant' },
  { code: 'leases:read_contract_pdf', module: 'leases', description: 'Télécharger le contrat PDF' },
  { code: 'leases:read_expiring', module: 'leases', description: 'Consulter les contrats arrivant à échéance' },

  // payments
  { code: 'payments:read', module: 'payments', description: 'Lister les paiements' },
  { code: 'payments:read_detail', module: 'payments', description: "Consulter le détail d'un paiement" },
  { code: 'payments:create', module: 'payments', description: 'Générer une échéance de paiement' },
  { code: 'payments:record', module: 'payments', description: 'Enregistrer un paiement' },
  { code: 'payments:read_receipt', module: 'payments', description: 'Télécharger une quittance' },
  { code: 'payments:read_overdue', module: 'payments', description: 'Consulter les loyers en retard' },
  { code: 'payments:read_own', module: 'payments', description: 'Consulter ses propres paiements' },
  {
    code: 'payments:read_own_properties',
    module: 'payments',
    description: 'Consulter les paiements liés à ses propres biens (propriétaire)',
  },

  // expenses
  { code: 'expenses:read', module: 'expenses', description: 'Lister les charges' },
  { code: 'expenses:create', module: 'expenses', description: 'Créer une charge' },
  { code: 'expenses:update', module: 'expenses', description: 'Modifier une charge' },
  { code: 'expenses:delete', module: 'expenses', description: 'Supprimer (soft) une charge' },
  { code: 'expenses:read_reports', module: 'expenses', description: 'Consulter les rapports de charges' },

  // maintenance
  { code: 'maintenance:read', module: 'maintenance', description: 'Lister les demandes de maintenance' },
  { code: 'maintenance:read_detail', module: 'maintenance', description: 'Consulter le détail d’une demande' },
  { code: 'maintenance:create', module: 'maintenance', description: 'Créer une demande de maintenance' },
  { code: 'maintenance:validate', module: 'maintenance', description: 'Valider une demande' },
  { code: 'maintenance:assign', module: 'maintenance', description: 'Assigner un technicien' },
  { code: 'maintenance:update_status', module: 'maintenance', description: 'Changer le statut (workflow)' },
  { code: 'maintenance:manage_attachments', module: 'maintenance', description: 'Gérer les photos avant/après' },
  { code: 'maintenance:read_own', module: 'maintenance', description: 'Consulter ses propres demandes' },

  // workers
  { code: 'workers:read', module: 'workers', description: 'Lister les ouvriers/prestataires' },
  { code: 'workers:create', module: 'workers', description: 'Ajouter un ouvrier/prestataire' },
  { code: 'workers:update', module: 'workers', description: 'Modifier un ouvrier/prestataire' },
  { code: 'workers:delete', module: 'workers', description: 'Supprimer un ouvrier/prestataire' },
  { code: 'workers:read_own', module: 'workers', description: 'Consulter les ouvriers de son propre bien (locataire)' },

  // visits
  { code: 'visits:read', module: 'visits', description: "Lister toutes les visites de l'organisation" },
  { code: 'visits:read_own', module: 'visits', description: 'Lister ses propres visites (agent)' },
  { code: 'visits:create', module: 'visits', description: 'Planifier une visite' },
  { code: 'visits:update', module: 'visits', description: 'Modifier une visite' },
  {
    code: 'visits:manage_outcome',
    module: 'visits',
    description: 'Marquer une visite comme réalisée/annulée avec un compte-rendu',
  },

  // notifications
  { code: 'notifications:read', module: 'notifications', description: 'Consulter ses notifications' },
  { code: 'notifications:manage', module: 'notifications', description: 'Marquer ses notifications comme lues' },

  // dashboard
  { code: 'dashboard:admin', module: 'dashboard', description: 'Consulter le dashboard ADMIN_AGENCE' },
  { code: 'dashboard:manager', module: 'dashboard', description: 'Consulter le dashboard GESTIONNAIRE' },
  { code: 'dashboard:tenant', module: 'dashboard', description: 'Consulter le dashboard LOCATAIRE' },
  { code: 'dashboard:owner', module: 'dashboard', description: 'Consulter le dashboard PROPRIETAIRE' },
  { code: 'dashboard:super_admin', module: 'dashboard', description: 'Consulter le dashboard SUPER_ADMIN' },

  // audit log
  { code: 'audit-log:read', module: 'audit-log', description: "Consulter le journal d'audit" },
];

/**
 * Permission matrix per RoleName, per spec §10. SUPER_ADMIN is intentionally omitted here:
 * it receives ALL permissions and additionally bypasses PermissionsGuard/RolesGuard entirely
 * (see common/guards), so its permission set is generated separately in the seed script.
 */
export const ROLE_PERMISSIONS: Record<Exclude<RoleName, 'SUPER_ADMIN'>, string[]> = {
  ADMIN_AGENCE: [
    'organizations:read_own',
    'organizations:update_own',
    'users:read',
    'users:create',
    'users:update',
    'users:change_role',
    'users:toggle_active',
    'users:delete',
    'users:upload_avatar',
    'roles:read',
    'roles:create',
    'roles:update_permissions',
    'permissions:read',
    'properties:read',
    'properties:create',
    'properties:update',
    'properties:delete',
    'properties:manage_images',
    'properties:read_history',
    'owners:read',
    'owners:create',
    'owners:update',
    'owners:delete',
    'tenants:read',
    'tenants:read_detail',
    'tenants:create',
    'tenants:update',
    'tenants:manage_documents',
    'tenants:delete',
    'leases:read',
    'leases:read_detail',
    'leases:create',
    'leases:update',
    'leases:renew',
    'leases:terminate',
    'leases:manage_amendments',
    'leases:read_contract_pdf',
    'leases:read_expiring',
    'payments:read',
    'payments:read_detail',
    'payments:read_receipt',
    'payments:read_overdue',
    'expenses:read',
    'expenses:create',
    'expenses:update',
    'expenses:delete',
    'expenses:read_reports',
    'maintenance:read',
    'maintenance:read_detail',
    'maintenance:validate',
    'maintenance:assign',
    'maintenance:update_status',
    'maintenance:manage_attachments',
    'workers:read',
    'workers:create',
    'workers:update',
    'workers:delete',
    'visits:read',
    'visits:create',
    'visits:update',
    'visits:manage_outcome',
    'notifications:read',
    'notifications:manage',
    'dashboard:admin',
    'audit-log:read',
  ],
  GESTIONNAIRE: [
    'organizations:read_own',
    'properties:read',
    'properties:create',
    'properties:update',
    'properties:manage_images',
    'properties:read_history',
    'owners:read',
    'owners:create',
    'owners:update',
    'owners:invite',
    'tenants:read',
    'tenants:read_detail',
    'tenants:create',
    'tenants:update',
    'tenants:manage_documents',
    'leases:read',
    'leases:read_detail',
    'leases:create',
    'leases:update',
    'leases:renew',
    'leases:terminate',
    'leases:manage_amendments',
    'leases:read_contract_pdf',
    'leases:read_expiring',
    'payments:read',
    'payments:read_detail',
    'payments:create',
    'payments:record',
    'payments:read_receipt',
    'payments:read_overdue',
    'expenses:read',
    'expenses:create',
    'expenses:update',
    'maintenance:read',
    'maintenance:read_detail',
    'maintenance:create',
    'maintenance:validate',
    'maintenance:assign',
    'maintenance:update_status',
    'maintenance:manage_attachments',
    'workers:read',
    'workers:create',
    'workers:update',
    'workers:delete',
    'visits:read',
    'visits:create',
    'visits:update',
    'visits:manage_outcome',
    'notifications:read',
    'notifications:manage',
    'dashboard:manager',
  ],
  AGENT_IMMOBILIER: [
    'organizations:read_own',
    'properties:read',
    'owners:read',
    'tenants:read',
    'tenants:create',
    'leases:read_detail',
    'maintenance:read_detail',
    'maintenance:create',
    'visits:read_own',
    'visits:create',
    'visits:update',
    'visits:manage_outcome',
    'notifications:read',
    'notifications:manage',
  ],
  LOCATAIRE: [
    'properties:read',
    'leases:read_detail',
    'leases:read_contract_pdf',
    'payments:read_detail',
    'payments:read_receipt',
    'payments:read_own',
    'maintenance:read_detail',
    'maintenance:create',
    'maintenance:read_own',
    'maintenance:manage_attachments',
    'workers:read_own',
    'notifications:read',
    'notifications:manage',
    'dashboard:tenant',
  ],
  PROPRIETAIRE: [
    'properties:read_own',
    'dashboard:owner',
    'payments:read_own_properties',
    'notifications:read',
    'notifications:manage',
  ],
};

export const ROLE_LABELS: Record<RoleName, string> = {
  SUPER_ADMIN: 'Super administrateur',
  ADMIN_AGENCE: "Administrateur d'agence",
  GESTIONNAIRE: 'Gestionnaire',
  AGENT_IMMOBILIER: 'Agent immobilier',
  LOCATAIRE: 'Locataire',
  PROPRIETAIRE: 'Propriétaire',
};
