/// Centralized route path/name constants used by go_router and by any
/// widget that needs to navigate without importing the router itself.
class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String unsupportedRole = '/unsupported-role';
  static const String invitationEntry = '/invitation';
  static const String activateAccount = '/invitation/activate';
  static const String ownerActivateAccount = '/invitation/owner-activate';

  // Tenant
  static const String tenantHome = '/tenant/home';
  static const String tenantLease = '/tenant/lease';
  static const String tenantPayments = '/tenant/payments';
  static const String tenantPaymentDetail = '/tenant/payments/:id';
  static const String tenantMaintenance = '/tenant/maintenance';
  static const String tenantMaintenanceNew = '/tenant/maintenance/new';
  static const String tenantMaintenanceDetail = '/tenant/maintenance/:id';
  static const String tenantNotifications = '/tenant/notifications';
  static const String tenantProfile = '/tenant/profile';

  static String tenantPaymentDetailPath(String id) => '/tenant/payments/$id';
  static String tenantMaintenanceDetailPath(String id) => '/tenant/maintenance/$id';

  // Agent
  static const String agentHome = '/agent/home';
  static const String agentProperties = '/agent/properties';
  static const String agentPropertyDetail = '/agent/properties/:id';
  static const String agentVisits = '/agent/visits';
  static const String agentVisitDetail = '/agent/visits/:id';
  static const String agentVisitNew = '/agent/visits/new';

  static String agentPropertyDetailPath(String id) => '/agent/properties/$id';
  static String agentVisitDetailPath(String id) => '/agent/visits/$id';

  // Owner
  static const String ownerHome = '/owner/home';
  static const String ownerProperties = '/owner/properties';
  static const String ownerPropertyDetail = '/owner/properties/:id';
  static const String ownerProfile = '/owner/profile';

  static String ownerPropertyDetailPath(String id) => '/owner/properties/$id';

  // Manager (GESTIONNAIRE - primary operator, spec §0/§8)
  static const String managerHome = '/manager/home';
  static const String managerOwners = '/manager/owners';
  static const String managerOwnerInvite = '/manager/owners/invite';
  static const String managerOwnerDetail = '/manager/owners/:id';
  static const String managerProperties = '/manager/properties';
  static const String managerPropertyDetail = '/manager/properties/:id';
  static const String managerPropertyNew = '/manager/properties/new';
  static const String managerTenants = '/manager/tenants';
  static const String managerTenantNew = '/manager/tenants/new';
  static const String managerLeases = '/manager/leases';
  static const String managerLeaseNew = '/manager/leases/new';
  static const String managerLeaseDetail = '/manager/leases/:id';
  static const String managerPayments = '/manager/payments';
  // Overflow menu (spec §8/§52): not primary tabs, reachable from the
  // manager home screen's account sheet.
  static const String managerMaintenanceQueue = '/manager/maintenance';
  static const String managerAssigned = '/manager/assigned';
  static const String managerAssignedDetail = '/manager/assigned/:id';
  static const String managerAssignedComplete = '/manager/assigned/:id/complete';
  static const String managerNotifications = '/manager/notifications';
  static const String managerProfile = '/manager/profile';

  static String managerOwnerDetailPath(String id) => '/manager/owners/$id';
  static String managerPropertyDetailPath(String id) => '/manager/properties/$id';
  static String managerLeaseDetailPath(String id) => '/manager/leases/$id';
  static String managerAssignedDetailPath(String id) => '/manager/assigned/$id';
  static String managerAssignedCompletePath(String id) => '/manager/assigned/$id/complete';
}
