/// Centralized route path/name constants used by go_router and by any
/// widget that needs to navigate without importing the router itself.
class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String unsupportedRole = '/unsupported-role';

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

  // Manager (field)
  static const String managerHome = '/manager/home';
  static const String managerAssigned = '/manager/assigned';
  static const String managerAssignedDetail = '/manager/assigned/:id';
  static const String managerAssignedComplete = '/manager/assigned/:id/complete';

  static String managerAssignedDetailPath(String id) => '/manager/assigned/$id';
  static String managerAssignedCompletePath(String id) => '/manager/assigned/$id/complete';
}
