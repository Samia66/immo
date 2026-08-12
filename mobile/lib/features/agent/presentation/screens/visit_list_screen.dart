import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/visit_model.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/refreshable_list_view.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../providers/agent_providers.dart';

class VisitListScreen extends ConsumerWidget {
  const VisitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(visitsListProvider);
    final notifier = ref.read(visitsListProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes visites')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.agentVisitNew),
        icon: const Icon(Icons.add),
        label: const Text('Planifier'),
      ),
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
                  for (final status in VisitStatus.values)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: status.label,
                        selected: notifier.statusFilter == status,
                        onTap: () => notifier.setStatusFilter(status),
                      ),
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
              child: RefreshableListView<VisitModel>(
                value: listState,
                onRefresh: notifier.refresh,
                emptyIcon: Icons.event_busy_outlined,
                emptyTitle: 'Aucune visite',
                emptyMessage: 'Planifiez une visite pour un client intéressé.',
                itemBuilder: (context, item) => AppCard(
                  onTap: () => context.push(AppRoutes.agentVisitDetailPath(item.id)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.clientName, style: theme.textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.dateTime(item.scheduledAt),
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: theme.colorScheme.outline),
                            ),
                            if (item.clientPhone != null) ...[
                              const SizedBox(height: 2),
                              Text(item.clientPhone!, style: theme.textTheme.bodySmall),
                            ],
                          ],
                        ),
                      ),
                      VisitStatusChip(status: item.status),
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
