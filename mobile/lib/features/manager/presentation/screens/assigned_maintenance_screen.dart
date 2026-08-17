import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/maintenance_model.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/refreshable_list_view.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../providers/manager_providers.dart';

class AssignedMaintenanceScreen extends ConsumerWidget {
  const AssignedMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(assignedMaintenanceProvider);
    final notifier = ref.read(assignedMaintenanceProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Interventions assignées')),
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
                  _FilterChip(label: 'Toutes', selected: notifier.statusFilter == null,
                      onTap: () => notifier.setStatusFilter(null)),
                  _FilterChip(
                    label: MaintenanceStatus.ASSIGNEE.label,
                    selected: notifier.statusFilter == MaintenanceStatus.ASSIGNEE,
                    onTap: () => notifier.setStatusFilter(MaintenanceStatus.ASSIGNEE),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: MaintenanceStatus.EN_COURS.label,
                    selected: notifier.statusFilter == MaintenanceStatus.EN_COURS,
                    onTap: () => notifier.setStatusFilter(MaintenanceStatus.EN_COURS),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: MaintenanceStatus.TERMINEE.label,
                    selected: notifier.statusFilter == MaintenanceStatus.TERMINEE,
                    onTap: () => notifier.setStatusFilter(MaintenanceStatus.TERMINEE),
                  ),
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
              child: RefreshableListView<MaintenanceRequestModel>(
                value: listState,
                onRefresh: notifier.refresh,
                emptyIcon: Icons.task_alt_outlined,
                emptyTitle: 'Aucune intervention',
                itemBuilder: (context, item) => AppCard(
                  onTap: () => context.push(AppRoutes.managerAssignedDetailPath(item.id)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.propertyUnit?.property.title ?? item.category,
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(item.category, style: theme.textTheme.bodySmall),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: theme.colorScheme.outline),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MaintenanceStatusChip(status: item.status),
                          const SizedBox(height: 6),
                          MaintenancePriorityChip(priority: item.priority),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap());
  }
}
