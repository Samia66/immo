import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/agent/presentation/screens/agent_home_screen.dart';
import '../../features/agent/presentation/screens/new_visit_screen.dart';
import '../../features/agent/presentation/screens/property_detail_screen.dart';
import '../../features/agent/presentation/screens/property_list_screen.dart';
import '../../features/agent/presentation/screens/visit_detail_screen.dart';
import '../../features/agent/presentation/screens/visit_list_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/unsupported_role_screen.dart';
import '../../features/manager/presentation/screens/assigned_maintenance_screen.dart';
import '../../features/manager/presentation/screens/maintenance_completion_screen.dart';
import '../../features/manager/presentation/screens/maintenance_intervention_screen.dart';
import '../../features/manager/presentation/screens/manager_home_screen.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/tenant/presentation/screens/lease_screen.dart';
import '../../features/tenant/presentation/screens/maintenance_detail_screen.dart';
import '../../features/tenant/presentation/screens/maintenance_list_screen.dart';
import '../../features/tenant/presentation/screens/new_maintenance_screen.dart';
import '../../features/tenant/presentation/screens/payment_detail_screen.dart';
import '../../features/tenant/presentation/screens/payments_screen.dart';
import '../../features/tenant/presentation/screens/tenant_home_screen.dart';
import '../../features/tenant/presentation/screens/tenant_profile_screen.dart';
import '../../shared/widgets/role_shell_scaffold.dart';
import '../constants/app_constants.dart';
import 'app_routes.dart';

/// Bridges Riverpod state changes into a [Listenable] go_router can use as
/// `refreshListenable`, so the router's `redirect` re-evaluates whenever
/// auth status changes (login, logout, forced logout from a failed refresh).
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authNotifierProvider, (previous, next) {
      if (previous?.status != next.status) notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    refreshListenable: refreshNotifier,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) =>
            ResetPasswordScreen(initialToken: state.uri.queryParameters['token']),
      ),
      GoRoute(
        path: AppRoutes.unsupportedRole,
        builder: (context, state) => const UnsupportedRoleScreen(),
      ),

      // --- Tenant --------------------------------------------------------
      ShellRoute(
        builder: (context, state, child) => Consumer(
          builder: (context, ref, _) {
            final unread = ref.watch(unreadCountProvider).valueOrNull ?? 0;
            return RoleShellScaffold(
              currentPath: state.matchedLocation,
              tabs: [
                const ShellTab(
                  path: AppRoutes.tenantHome,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Accueil',
                ),
                const ShellTab(
                  path: AppRoutes.tenantPayments,
                  icon: Icons.payments_outlined,
                  selectedIcon: Icons.payments,
                  label: 'Paiements',
                ),
                const ShellTab(
                  path: AppRoutes.tenantMaintenance,
                  icon: Icons.build_outlined,
                  selectedIcon: Icons.build,
                  label: 'Maintenance',
                ),
                ShellTab(
                  path: AppRoutes.tenantProfile,
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: 'Profil',
                  badgeCount: unread,
                ),
              ],
              child: child,
            );
          },
        ),
        routes: [
          GoRoute(path: AppRoutes.tenantHome, builder: (context, state) => const TenantHomeScreen()),
          GoRoute(path: AppRoutes.tenantPayments, builder: (context, state) => const PaymentsScreen()),
          GoRoute(
            path: AppRoutes.tenantMaintenance,
            builder: (context, state) => const MaintenanceListScreen(),
          ),
          GoRoute(
            path: AppRoutes.tenantProfile,
            builder: (context, state) => const TenantProfileScreen(),
          ),
        ],
      ),
      GoRoute(path: AppRoutes.tenantLease, builder: (context, state) => const LeaseScreen()),
      GoRoute(
        path: AppRoutes.tenantPaymentDetail,
        builder: (context, state) =>
            PaymentDetailScreen(paymentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.tenantMaintenanceNew,
        builder: (context, state) => const NewMaintenanceScreen(),
      ),
      GoRoute(
        path: AppRoutes.tenantMaintenanceDetail,
        builder: (context, state) =>
            MaintenanceDetailScreen(requestId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.tenantNotifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // --- Agent -----------------------------------------------------------
      ShellRoute(
        builder: (context, state, child) => RoleShellScaffold(
          currentPath: state.matchedLocation,
          tabs: const [
            ShellTab(
              path: AppRoutes.agentHome,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'Accueil',
            ),
            ShellTab(
              path: AppRoutes.agentProperties,
              icon: Icons.apartment_outlined,
              selectedIcon: Icons.apartment,
              label: 'Biens',
            ),
            ShellTab(
              path: AppRoutes.agentVisits,
              icon: Icons.event_available_outlined,
              selectedIcon: Icons.event_available,
              label: 'Visites',
            ),
          ],
          child: child,
        ),
        routes: [
          GoRoute(path: AppRoutes.agentHome, builder: (context, state) => const AgentHomeScreen()),
          GoRoute(
            path: AppRoutes.agentProperties,
            builder: (context, state) => const PropertyListScreen(),
          ),
          GoRoute(path: AppRoutes.agentVisits, builder: (context, state) => const VisitListScreen()),
        ],
      ),
      GoRoute(
        path: AppRoutes.agentPropertyDetail,
        builder: (context, state) =>
            PropertyDetailScreen(propertyId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.agentVisitDetail,
        builder: (context, state) => VisitDetailScreen(visitId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.agentVisitNew,
        builder: (context, state) =>
            NewVisitScreen(initialPropertyId: state.extra as String?),
      ),

      // --- Manager (field) ---------------------------------------------
      ShellRoute(
        builder: (context, state, child) => RoleShellScaffold(
          currentPath: state.matchedLocation,
          tabs: const [
            ShellTab(
              path: AppRoutes.managerHome,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'Accueil',
            ),
            ShellTab(
              path: AppRoutes.managerAssigned,
              icon: Icons.assignment_outlined,
              selectedIcon: Icons.assignment,
              label: 'Interventions',
            ),
          ],
          child: child,
        ),
        routes: [
          GoRoute(path: AppRoutes.managerHome, builder: (context, state) => const ManagerHomeScreen()),
          GoRoute(
            path: AppRoutes.managerAssigned,
            builder: (context, state) => const AssignedMaintenanceScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.managerAssignedDetail,
        builder: (context, state) =>
            MaintenanceInterventionScreen(requestId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.managerAssignedComplete,
        builder: (context, state) =>
            MaintenanceCompletionScreen(requestId: state.pathParameters['id']!),
      ),
    ],
  );
});

String? _redirect(Ref ref, GoRouterState state) {
  final authState = ref.read(authNotifierProvider);
  final location = state.matchedLocation;

  final isPublicAuthRoute = location == AppRoutes.login ||
      location == AppRoutes.forgotPassword ||
      location == AppRoutes.resetPassword;
  final isSplash = location == AppRoutes.splash;
  final isUnsupportedRoleScreen = location == AppRoutes.unsupportedRole;

  switch (authState.status) {
    case AuthStatus.unknown:
      return isSplash ? null : AppRoutes.splash;

    case AuthStatus.authenticating:
      // Stay put while a login attempt is in flight.
      return null;

    case AuthStatus.unauthenticated:
      return isPublicAuthRoute ? null : AppRoutes.login;

    case AuthStatus.unsupportedRole:
      return isUnsupportedRoleScreen ? null : AppRoutes.unsupportedRole;

    case AuthStatus.authenticated:
      final role = authState.role;
      if (role == null) return AppRoutes.login;

      final homePath = switch (role) {
        MobileRole.tenant => AppRoutes.tenantHome,
        MobileRole.agent => AppRoutes.agentHome,
        MobileRole.manager => AppRoutes.managerHome,
      };

      if (isSplash || isPublicAuthRoute || isUnsupportedRoleScreen) return homePath;

      final inOwnRoleSection = switch (role) {
        MobileRole.tenant => location.startsWith('/tenant'),
        MobileRole.agent => location.startsWith('/agent'),
        MobileRole.manager => location.startsWith('/manager'),
      };
      if (!inOwnRoleSection) return homePath;

      return null;
  }
}
