import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/lease_model.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../providers/tenant_providers.dart';

class LeaseScreen extends ConsumerWidget {
  const LeaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(tenantDashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mon bail')),
      body: dashboardState.when(
        loading: () => const SkeletonList(),
        error: (error, stackTrace) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.read(tenantDashboardProvider.notifier).refresh(),
        ),
        data: (dashboard) {
          final activeLease = dashboard.activeLease;
          if (activeLease == null) {
            return const EmptyStateView(
              icon: Icons.home_work_outlined,
              title: 'Aucun bail actif',
              message: "Vous n'avez pas de contrat de location actif pour le moment.",
            );
          }
          final detailAsync = ref.watch(leaseDetailProvider(activeLease.id));
          return RefreshIndicator(
            onRefresh: () => ref.refresh(leaseDetailProvider(activeLease.id).future),
            child: detailAsync.when(
              loading: () => const SkeletonList(),
              error: (error, stackTrace) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(leaseDetailProvider(activeLease.id)),
              ),
              data: (lease) => ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                lease.property?.title ?? activeLease.property.title,
                                style: theme.textTheme.titleLarge,
                              ),
                            ),
                            LeaseStatusChip(status: lease.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lease.property?.reference ?? activeLease.property.reference,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.outline),
                        ),
                        const Divider(height: 32),
                        _InfoRow(label: 'Loyer mensuel', value: Formatters.amount(lease.rentAmount)),
                        _InfoRow(label: 'Dépôt de garantie', value: Formatters.amount(lease.depositAmount)),
                        _InfoRow(label: 'Fréquence de paiement', value: lease.paymentFrequency.label),
                        _InfoRow(label: 'Date de début', value: Formatters.date(lease.startDate)),
                        _InfoRow(
                          label: 'Date de fin',
                          value: lease.endDate != null ? Formatters.date(lease.endDate) : 'Indéterminée',
                        ),
                        if (lease.indexationRate != null)
                          _InfoRow(
                            label: 'Taux de révision',
                            value: '${lease.indexationRate!.toStringAsFixed(1)} %',
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
