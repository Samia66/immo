import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/models/owner_model.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import '../../../../../shared/widgets/refreshable_list_view.dart';
import '../../providers/manager_owner_providers.dart';

/// "Mes propriétaires" - the manager's own owner portfolio (spec §5.2/§6):
/// `GET /owners`, already scoped server-side to owners this manager manages.
class ManagerOwnersScreen extends ConsumerStatefulWidget {
  const ManagerOwnersScreen({super.key});

  @override
  ConsumerState<ManagerOwnersScreen> createState() => _ManagerOwnersScreenState();
}

class _ManagerOwnersScreenState extends ConsumerState<ManagerOwnersScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(managerOwnersListProvider);
    final notifier = ref.read(managerOwnersListProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes propriétaires'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un propriétaire...',
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
              child: RefreshableListView<OwnerModel>(
                value: listState,
                onRefresh: notifier.refresh,
                emptyIcon: Icons.villa_outlined,
                emptyTitle: 'Aucun propriétaire',
                emptyMessage: "Invitez-en un pour commencer à gérer des biens.",
                itemBuilder: (context, owner) => AppCard(
                  onTap: () => context.push(AppRoutes.managerOwnerDetailPath(owner.id)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          owner.fullName.isNotEmpty ? owner.fullName[0].toUpperCase() : '?',
                          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(owner.fullName, style: theme.textTheme.titleSmall),
                            Text(owner.phone,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: theme.colorScheme.outline)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: theme.colorScheme.outline),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.managerOwnerInvite),
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Inviter'),
      ),
    );
  }
}
