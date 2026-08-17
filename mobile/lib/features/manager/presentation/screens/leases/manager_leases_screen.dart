import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/models/lease_model.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import '../../../../../shared/widgets/refreshable_list_view.dart';
import '../../../../../shared/widgets/status_chip.dart';
import '../../providers/manager_lease_providers.dart';

/// Manager (GESTIONNAIRE) contracts list: `GET /leases`, scoped server-side
/// to this manager's own leases. Filterable by any of the 9 real
/// `LeaseStatus` states.
class ManagerLeasesScreen extends ConsumerWidget {
  const ManagerLeasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(managerLeasesListProvider);
    final notifier = ref.read(managerLeasesListProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Contrats')),
      body: Column(
        children: [
          const OfflineBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChip(
                    label: const Text('Tous'),
                    selected: notifier.statusFilter == null,
                    onSelected: (_) => notifier.setStatusFilter(null),
                  ),
                  for (final status in LeaseStatus.values) ...[
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(status.label),
                      selected: notifier.statusFilter == status,
                      onSelected: (_) => notifier.setStatusFilter(status),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels > notification.metrics.maxScrollExtent - 200) {
                  notifier.loadMore();
                }
                return false;
              },
              child: RefreshableListView<LeaseModel>(
                value: listState,
                onRefresh: notifier.refresh,
                emptyIcon: Icons.description_outlined,
                emptyTitle: 'Aucun contrat',
                emptyMessage: 'Créez un contrat pour un locataire et un lot disponible.',
                itemBuilder: (context, lease) => AppCard(
                  onTap: () => context.push(AppRoutes.managerLeaseDetailPath(lease.id)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lease.reference, style: theme.textTheme.titleSmall),
                            const SizedBox(height: 2),
                            if (lease.propertyUnit != null)
                              Text(
                                '${lease.propertyUnit!.displayLabel} · ${lease.propertyUnit!.property.title}',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: theme.colorScheme.outline),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (lease.tenant != null)
                              Text(lease.tenant!.fullName, style: theme.textTheme.bodySmall),
                            const SizedBox(height: 4),
                            Text(Formatters.amount(lease.rentAmount),
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(color: theme.colorScheme.primary)),
                          ],
                        ),
                      ),
                      LeaseStatusChip(status: lease.status),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.managerLeaseNew),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau contrat'),
      ),
    );
  }
}
