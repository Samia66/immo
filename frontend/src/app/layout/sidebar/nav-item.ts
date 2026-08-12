export interface NavItem {
  label: string;
  icon: string;
  link: string;
  /** Permission code required to see this item; omit for always-visible items. */
  permission?: string;
}

export const NAV_ITEMS: NavItem[] = [
  { label: 'Tableau de bord', icon: 'space_dashboard', link: '/app/dashboard' },
  { label: 'Biens', icon: 'home_work', link: '/app/properties', permission: 'properties:read' },
  { label: 'Propriétaires', icon: 'badge', link: '/app/owners', permission: 'owners:read' },
  { label: 'Locataires', icon: 'groups', link: '/app/tenants', permission: 'tenants:read' },
  { label: 'Contrats', icon: 'description', link: '/app/leases', permission: 'leases:read' },
  { label: 'Paiements', icon: 'payments', link: '/app/payments', permission: 'payments:read' },
  { label: 'Maintenance', icon: 'build', link: '/app/maintenance', permission: 'maintenance:read' },
  { label: 'Notifications', icon: 'notifications', link: '/app/notifications' },
];

export const SETTINGS_NAV_ITEMS: NavItem[] = [
  { label: 'Organisation', icon: 'apartment', link: '/app/settings/organization' },
  { label: 'Utilisateurs', icon: 'manage_accounts', link: '/app/settings/users' },
  { label: 'Rôles & permissions', icon: 'admin_panel_settings', link: '/app/settings/roles-permissions' },
];
