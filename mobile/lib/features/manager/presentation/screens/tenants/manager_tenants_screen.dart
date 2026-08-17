import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/models/tenant_model.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import '../../../../../shared/widgets/refreshable_list_view.dart';
import '../../providers/manager_tenant_providers.dart';

/// Manager (GESTIONNAIRE) tenant roster: `GET /tenants`, scoped
/// server-side to tenants on this manager's leases.
class ManagerTenantsScreen extends ConsumerStatefulWidget {
  const ManagerTenantsScreen({super.key});

  @override
  ConsumerState<ManagerTenantsScreen> createState() => _ManagerTenantsScreenState();
}

class _ManagerTenantsScreenState extends ConsumerState<ManagerTenantsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(managerTenantsListProvider);
    final notifier = ref.read(managerTenantsListProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locataires'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un locataire...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          notifier.setSearch(null);
                        },
                      )
                    : null,
              ),
              onSubmitted: (value) => notifier.setSearch(value.isEmpty ? null : value),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels > notification.metrics.maxScrollExtent - 200) {
                  notifier.loadMore();
                }
                return false;
              },
              child: RefreshableListView<TenantModel>(
                value: listState,
                onRefresh: notifier.refresh,
                emptyIcon: Icons.people_outline,
                emptyTitle: 'Aucun locataire',
                emptyMessage: 'Ajoutez un locataire pour lui créer un contrat.',
                itemBuilder: (context, tenant) => AppCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          tenant.fullName.isNotEmpty ? tenant.fullName[0].toUpperCase() : '?',
                          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tenant.fullName, style: theme.textTheme.titleSmall),
                            Text(tenant.phone,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: theme.colorScheme.outline)),
                          ],
                        ),
                      ),
                      if (tenant.userId != null)
                        Icon(Icons.verified_outlined, size: 18, color: theme.colorScheme.primary),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.managerTenantNew),
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Ajouter'),
      ),
    );
  }
}
