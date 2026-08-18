import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/models/worker_model.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import '../../../../../shared/widgets/refreshable_list_view.dart';
import '../../providers/manager_worker_providers.dart';

/// Manager (GESTIONNAIRE) worker/contractor address book: `GET /workers`,
/// scoped server-side to this manager's own managed properties (plus
/// "general" workers with no property).
class ManagerWorkersScreen extends ConsumerStatefulWidget {
  const ManagerWorkersScreen({super.key});

  @override
  ConsumerState<ManagerWorkersScreen> createState() => _ManagerWorkersScreenState();
}

class _ManagerWorkersScreenState extends ConsumerState<ManagerWorkersScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(managerWorkersListProvider);
    final notifier = ref.read(managerWorkersListProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ouvriers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un ouvrier...',
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
              child: RefreshableListView<WorkerModel>(
                value: listState,
                onRefresh: notifier.refresh,
                emptyIcon: Icons.engineering_outlined,
                emptyTitle: 'Aucun ouvrier',
                emptyMessage: 'Ajoutez un plombier, électricien... que vos locataires pourront contacter.',
                itemBuilder: (context, worker) => AppCard(
                  onTap: () => context.push(AppRoutes.managerWorkerDetailPath(worker.id)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          worker.fullName.isNotEmpty ? worker.fullName[0].toUpperCase() : '?',
                          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(worker.fullName, style: theme.textTheme.titleSmall),
                            Text('${worker.trade} · ${worker.phone}',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: theme.colorScheme.outline)),
                          ],
                        ),
                      ),
                      if (!worker.isActive)
                        Icon(Icons.visibility_off_outlined, size: 18, color: theme.colorScheme.outline),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.managerWorkerNew),
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Ajouter'),
      ),
    );
  }
}
