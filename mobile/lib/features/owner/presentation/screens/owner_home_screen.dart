import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/owner_dashboard_model.dart';
import '../../../../core/models/property_model.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/account_sheet.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/owner_providers.dart';

class OwnerHomeScreen extends ConsumerWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    final dashboardState = ref.watch(ownerDashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(user != null ? 'Bonjour ${user.firstName}' : 'Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => showAccountSheet(context, ref, roleLabel: 'Propriétaire'),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(ownerDashboardProvider.notifier).refresh(),
              child: dashboardState.when(
                loading: () => const SkeletonList(),
                error: (error, stackTrace) => ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.read(ownerDashboardProvider.notifier).refresh(),
                ),
                data: (dashboard) => ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.apartment_outlined,
                            label: 'Lots au total',
                            value: '${dashboard.totalUnits}',
                            onTap: () => context.push(AppRoutes.ownerProperties),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.payments_outlined,
                            label: 'Revenu du mois',
                            value: Formatters.amount(dashboard.monthlyRevenue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Occupation', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        children: [
                          for (final entry in dashboard.byStatus)
                            _OccupancyRow(entry: entry),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Paiements', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _PaymentStatCard(
                            icon: Icons.hourglass_empty,
                            color: Colors.orange,
                            label: 'En attente',
                            count: dashboard.pendingCount,
                            amount: dashboard.pendingAmount,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PaymentStatCard(
                            icon: Icons.warning_amber_outlined,
                            color: Colors.red,
                            label: 'En retard',
                            count: dashboard.overdueCount,
                            amount: dashboard.overdueAmount,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value, this.onTap});

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
          Text(value, style: theme.textTheme.headlineSmall, overflow: TextOverflow.ellipsis),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
        ],
      ),
    );
  }
}

class _OccupancyRow extends StatelessWidget {
  const _OccupancyRow({required this.entry});

  final PropertyStatusCount entry;

  Color _color(BuildContext context) => switch (entry.status) {
        PropertyStatus.DISPONIBLE => Colors.green,
        PropertyStatus.OCCUPE => Colors.blueGrey,
        PropertyStatus.RESERVE => Colors.orange,
        PropertyStatus.MAINTENANCE => Colors.red,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _color(context)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(entry.status.label, style: theme.textTheme.bodyMedium)),
          Text('${entry.count}', style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _PaymentStatCard extends StatelessWidget {
  const _PaymentStatCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.count,
    required this.amount,
  });

  final IconData icon;
  final Color color;
  final String label;
  final int count;
  final num amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text('$count', style: theme.textTheme.headlineSmall),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
          const SizedBox(height: 4),
          Text(Formatters.amount(amount), style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
