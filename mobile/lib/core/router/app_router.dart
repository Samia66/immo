import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/agent/presentation/screens/agent_home_screen.dart';
import '../../features/agent/presentation/screens/new_visit_screen.dart';
import '../../features/agent/presentation/screens/property_detail_screen.dart';
import '../../features/agent/presentation/screens/property_list_screen.dart';
import '../../features/agent/presentation/screens/visit_detail_screen.dart';
import '../../features/agent/presentation/screens/visit_list_screen.dart';
import '../../core/models/invitation_model.dart';
import '../../core/models/owner_invitation_model.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/activate_account_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/invitation_entry_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/owner_activate_account_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/unsupported_role_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/manager/presentation/screens/assigned_maintenance_screen.dart';
import '../../features/manager/presentation/screens/leases/manager_lease_detail_screen.dart';
import '../../features/manager/presentation/screens/leases/manager_leases_screen.dart';
import '../../features/manager/presentation/screens/leases/new_lease_screen.dart';
import '../../features/manager/presentation/screens/maintenance_completion_screen.dart';
import '../../features/manager/presentation/screens/maintenance_intervention_screen.dart';
import '../../features/manager/presentation/screens/manager_maintenance_queue_screen.dart';
import '../../features/manager/presentation/screens/manager_home_screen.dart';
import '../../features/manager/presentation/screens/manager_profile_screen.dart';
import '../../features/manager/presentation/screens/manager_property_detail_screen.dart';
import '../../features/manager/presentation/screens/manager_property_list_screen.dart';
import '../../features/manager/presentation/screens/new_property_screen.dart';
import '../../features/manager/presentation/screens/owners/manager_owners_screen.dart';
import '../../features/manager/presentation/screens/owners/new_owner_invitation_screen.dart';
import '../../features/manager/presentation/screens/owners/owner_detail_screen.dart';
import '../../features/manager/presentation/screens/payments/manager_payments_screen.dart';
import '../../features/manager/presentation/screens/tenants/manager_tenants_screen.dart';
import '../../features/manager/presentation/screens/tenants/new_tenant_screen.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/owner/presentation/screens/owner_home_screen.dart';
import '../../features/owner/presentation/screens/owner_properties_screen.dart';
import '../../features/owner/presentation/screens/owner_property_detail_screen.dart';
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
      GoRoute(path: AppRoutes.welcome, builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),
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
      GoRoute(
        path: AppRoutes.invitationEntry,
        builder: (context, state) => const InvitationEntryScreen(),
      ),
      GoRoute(
        path: AppRoutes.activateAccount,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ActivateAccountScreen(
            code: extra?['code'] as String? ?? '',
            preview: extra?['preview'] as InvitationPreviewModel,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.ownerActivateAccount,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OwnerActivateAccountScreen(
            code: extra?['code'] as String? ?? '',
            preview: extra?['preview'] as OwnerInvitationPreviewModel,
          );
        },
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
      // Static "new" path must be registered before the ":id" detail route below — same
      // ordering pitfall as the manager property routes (go_router matches in declaration
      // order and does not prioritize static segments over parameterized ones).
      GoRoute(
        path: AppRoutes.agentVisitNew,
        builder: (context, state) =>
            NewVisitScreen(initialPropertyId: state.extra as String?),
      ),
      GoRoute(
        path: AppRoutes.agentVisitDetail,
        builder: (context, state) => VisitDetailScreen(visitId: state.pathParameters['id']!),
      ),

      // --- Manager (GESTIONNAIRE) -----------------------------------------
      // Primary tabs per spec §8/§52: Accueil/Propriétaires/Biens/Contrats/
      // Paiements. Locataires/Maintenance/Documents/Notifications/Profil/
      // Paramètres are reachable from the home screen's account-sheet
      // overflow menu instead (see [ManagerHomeScreen]) - Maintenance moved
      // out of the primary tabs here, matching its prior field-manager route.
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
              path: AppRoutes.managerOwners,
              icon: Icons.villa_outlined,
              selectedIcon: Icons.villa,
              label: 'Propriétaires',
            ),
            ShellTab(
              path: AppRoutes.managerProperties,
              icon: Icons.apartment_outlined,
              selectedIcon: Icons.apartment,
              label: 'Biens',
            ),
            ShellTab(
              path: AppRoutes.managerLeases,
              icon: Icons.description_outlined,
              selectedIcon: Icons.description,
              label: 'Contrats',
            ),
            ShellTab(
              path: AppRoutes.managerPayments,
              icon: Icons.payments_outlined,
              selectedIcon: Icons.payments,
              label: 'Paiements',
            ),
          ],
          child: child,
        ),
        routes: [
          GoRoute(path: AppRoutes.managerHome, builder: (context, state) => const ManagerHomeScreen()),
          GoRoute(
            path: AppRoutes.managerOwners,
            builder: (context, state) => const ManagerOwnersScreen(),
          ),
          GoRoute(
            path: AppRoutes.managerProperties,
            builder: (context, state) => const ManagerPropertyListScreen(),
          ),
          GoRoute(
            path: AppRoutes.managerLeases,
            builder: (context, state) => const ManagerLeasesScreen(),
          ),
          GoRoute(
            path: AppRoutes.managerPayments,
            builder: (context, state) => const ManagerPaymentsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.managerOwnerInvite,
        builder: (context, state) => const NewOwnerInvitationScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerOwnerDetail,
        builder: (context, state) => OwnerDetailScreen(ownerId: state.pathParameters['id']!),
      ),
      // Static "new" path must be registered before the ":id" detail route below — go_router
      // matches routes in declaration order and does not prioritize static segments over
      // parameterized ones (unlike Angular), so ":id" would otherwise greedily match "new" too.
      GoRoute(
        path: AppRoutes.managerPropertyNew,
        builder: (context, state) => const NewPropertyScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerPropertyDetail,
        builder: (context, state) =>
            ManagerPropertyDetailScreen(propertyId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.managerTenants,
        builder: (context, state) => const ManagerTenantsScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerTenantNew,
        builder: (context, state) => const NewTenantScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerLeaseNew,
        builder: (context, state) => const NewLeaseScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerLeaseDetail,
        builder: (context, state) => ManagerLeaseDetailScreen(leaseId: state.pathParameters['id']!),
      ),
      // --- Manager overflow menu (spec §8/§52) ----------------------------
      GoRoute(
        path: AppRoutes.managerMaintenanceQueue,
        builder: (context, state) => const ManagerMaintenanceQueueScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerAssigned,
        builder: (context, state) => const AssignedMaintenanceScreen(),
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
      GoRoute(
        path: AppRoutes.managerNotifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerProfile,
        builder: (context, state) => const ManagerProfileScreen(),
      ),

      // --- Owner (PROPRIETAIRE) ------------------------------------------
      ShellRoute(
        builder: (context, state, child) => RoleShellScaffold(
          currentPath: state.matchedLocation,
          tabs: const [
            ShellTab(
              path: AppRoutes.ownerHome,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'Accueil',
            ),
            ShellTab(
              path: AppRoutes.ownerProperties,
              icon: Icons.apartment_outlined,
              selectedIcon: Icons.apartment,
              label: 'Biens',
            ),
          ],
          child: child,
        ),
        routes: [
          GoRoute(path: AppRoutes.ownerHome, builder: (context, state) => const OwnerHomeScreen()),
          GoRoute(
            path: AppRoutes.ownerProperties,
            builder: (context, state) => const OwnerPropertiesScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.ownerPropertyDetail,
        builder: (context, state) =>
            OwnerPropertyDetailScreen(propertyId: state.pathParameters['id']!),
      ),
    ],
  );
});

String? _redirect(Ref ref, GoRouterState state) {
  final authState = ref.read(authNotifierProvider);
  final location = state.matchedLocation;

  final isPublicAuthRoute = location == AppRoutes.welcome ||
      location == AppRoutes.login ||
      location == AppRoutes.register ||
      location == AppRoutes.forgotPassword ||
      location == AppRoutes.resetPassword ||
      location == AppRoutes.invitationEntry ||
      location == AppRoutes.activateAccount ||
      location == AppRoutes.ownerActivateAccount;
  final isSplash = location == AppRoutes.splash;
  final isUnsupportedRoleScreen = location == AppRoutes.unsupportedRole;

  switch (authState.status) {
    case AuthStatus.unknown:
      return isSplash ? null : AppRoutes.splash;

    case AuthStatus.authenticating:
      // Stay put while a login attempt is in flight.
      return null;

    case AuthStatus.unauthenticated:
      // Welcome ("Se connecter"/"Créer un compte") replaces going straight
      // to the login screen (spec §5.1) - a visitor with no stored session
      // lands here first; login/register/invitation flows are still reached
      // by pushing from it.
      return isPublicAuthRoute ? null : AppRoutes.welcome;

    case AuthStatus.unsupportedRole:
      return isUnsupportedRoleScreen ? null : AppRoutes.unsupportedRole;

    case AuthStatus.authenticated:
      final role = authState.role;
      if (role == null) return AppRoutes.login;

      final homePath = switch (role) {
        MobileRole.tenant => AppRoutes.tenantHome,
        MobileRole.agent => AppRoutes.agentHome,
        MobileRole.manager => AppRoutes.managerHome,
        MobileRole.owner => AppRoutes.ownerHome,
      };

      if (isSplash || isPublicAuthRoute || isUnsupportedRoleScreen) return homePath;

      final inOwnRoleSection = switch (role) {
        MobileRole.tenant => location.startsWith('/tenant'),
        MobileRole.agent => location.startsWith('/agent'),
        MobileRole.manager => location.startsWith('/manager'),
        MobileRole.owner => location.startsWith('/owner'),
      };
      if (!inOwnRoleSection) return homePath;

      return null;
  }
}
