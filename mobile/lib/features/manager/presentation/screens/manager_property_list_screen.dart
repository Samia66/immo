import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../agent/presentation/screens/property_list_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/manager_owner_providers.dart';
import '../providers/manager_property_providers.dart';

/// Manager (GESTIONNAIRE) property browsing tab.
///
/// Reuses [PropertyListScreen] wholesale (filters, pull-to-refresh,
/// empty/loading states) instead of reimplementing it, pointing it at the
/// manager's own paginated list provider and detail route, and adding a
/// permission-gated "add property" FAB - GESTIONNAIRE has full
/// `properties:create` server-side, but the FAB only shows when the
/// logged-in user's permissions actually include it, mirroring the web
/// admin's `hasPermission('properties:create')` check.
///
/// V2 pivot: `POST /properties` now also requires a real `ownerId` this
/// manager actually manages, so a manager with zero owners gets a FAB that
/// redirects to "Inviter un propriétaire" instead of a create form with an
/// empty owner picker that would just 403.
class ManagerPropertyListScreen extends ConsumerWidget {
  const ManagerPropertyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(authNotifierProvider).user?.permissions ?? const [];
    final canCreate = permissions.contains('properties:create');
    final hasOwnersAsync = ref.watch(managerHasOwnersProvider);

    Widget? fab;
    if (canCreate) {
      final hasOwners = hasOwnersAsync.valueOrNull;
      if (hasOwners == false) {
        fab = FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.managerOwnerInvite),
          icon: const Icon(Icons.person_add_alt_1_outlined),
          label: const Text('Inviter un propriétaire'),
        );
      } else {
        fab = FloatingActionButton(
          onPressed: () => context.push(AppRoutes.managerPropertyNew),
          tooltip: 'Ajouter un bien',
          child: const Icon(Icons.add),
        );
      }
    }

    return PropertyListScreen(
      listProvider: managerPropertiesListProvider,
      detailPathBuilder: AppRoutes.managerPropertyDetailPath,
      floatingActionButton: fab,
    );
  }
}
