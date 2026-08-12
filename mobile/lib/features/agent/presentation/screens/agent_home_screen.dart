import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/visit_model.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/account_sheet.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/agent_providers.dart';

class AgentHomeScreen extends ConsumerWidget {
  const AgentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    final visitsState = ref.watch(visitsListProvider);
    final propertiesState = ref.watch(propertiesListProvider);
    final theme = Theme.of(context);

    final upcomingVisits = visitsState.maybeWhen(
      data: (visits) => visits
          .where((v) => v.status == VisitStatus.PLANIFIEE && v.scheduledAt.isAfter(DateTime.now()))
          .toList()
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt)),
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(user != null ? 'Bonjour ${user.firstName}' : 'Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => showAccountSheet(context, ref, roleLabel: 'Agent immobilier'),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(visitsListProvider.notifier).refresh();
                await ref.read(propertiesListProvider.notifier).refresh();
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.apartment_outlined,
                          label: 'Biens disponibles',
                          value: propertiesState.maybeWhen(
                            data: (items) => '${items.length}',
                            orElse: () => '...',
                          ),
                          onTap: () => context.push(AppRoutes.agentProperties),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.event_available_outlined,
                          label: 'Visites à venir',
                          value: upcomingVisits == null ? '...' : '${upcomingVisits.length}',
                          onTap: () => context.push(AppRoutes.agentVisits),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Prochaines visites', style: theme.textTheme.titleSmall),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.agentVisits),
                        child: const Text('Tout voir'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (upcomingVisits == null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (upcomingVisits.isEmpty)
                    AppCard(
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: theme.colorScheme.outline),
                          const SizedBox(width: 12),
                          const Expanded(child: Text('Aucune visite planifiée.')),
                        ],
                      ),
                    )
                  else
                    for (final visit in upcomingVisits.take(4))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          onTap: () => context.push(AppRoutes.agentVisitDetailPath(visit.id)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(visit.clientName, style: theme.textTheme.titleSmall),
                                    Text(
                                      Formatters.dateTime(visit.scheduledAt),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: theme.colorScheme.outline),
                                    ),
                                  ],
                                ),
                              ),
                              VisitStatusChip(status: visit.status),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.agentVisitNew),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Planifier une visite'),
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
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
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
