import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/maintenance_model.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/account_sheet.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/manager_providers.dart';

class ManagerHomeScreen extends ConsumerWidget {
  const ManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    final assignedState = ref.watch(assignedMaintenanceProvider);
    final theme = Theme.of(context);

    final toStart = assignedState.maybeWhen(
      data: (items) => items.where((m) => m.status == MaintenanceStatus.ASSIGNEE).toList(),
      orElse: () => null,
    );
    final inProgress = assignedState.maybeWhen(
      data: (items) => items.where((m) => m.status == MaintenanceStatus.EN_COURS).toList(),
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(user != null ? 'Bonjour ${user.firstName}' : 'Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => showAccountSheet(context, ref, roleLabel: 'Gestionnaire terrain'),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(assignedMaintenanceProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.assignment_late_outlined,
                          label: 'À démarrer',
                          value: toStart == null ? '...' : '${toStart.length}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.construction_outlined,
                          label: 'En cours',
                          value: inProgress == null ? '...' : '${inProgress.length}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mes interventions', style: theme.textTheme.titleSmall),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.managerAssigned),
                        child: const Text('Tout voir'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  assignedState.maybeWhen(
                    data: (items) {
                      if (items.isEmpty) {
                        return AppCard(
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline, color: theme.colorScheme.outline),
                              const SizedBox(width: 12),
                              const Expanded(child: Text('Aucune intervention assignée.')),
                            ],
                          ),
                        );
                      }
                      return Column(
                        children: [
                          for (final item in items.take(5))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AppCard(
                                onTap: () =>
                                    context.push(AppRoutes.managerAssignedDetailPath(item.id)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.property?.title ?? item.category,
                                              style: theme.textTheme.titleSmall),
                                          Text(item.category, style: theme.textTheme.bodySmall),
                                          if (item.scheduledAt != null)
                                            Text(
                                              Formatters.dateTime(item.scheduledAt),
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(color: theme.colorScheme.outline),
                                            ),
                                        ],
                                      ),
                                    ),
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
                        ],
                      );
                    },
                    orElse: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.headlineSmall),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
        ],
      ),
    );
  }
}
