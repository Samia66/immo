import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/maintenance_model.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/notifications_provider.dart';
import '../providers/tenant_providers.dart';

class TenantHomeScreen extends ConsumerWidget {
  const TenantHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(tenantDashboardProvider);
    final maintenanceState = ref.watch(tenantMaintenanceProvider);
    final user = ref.watch(authNotifierProvider).user;
    final theme = Theme.of(context);

    final openMaintenanceCount = maintenanceState.maybeWhen(
      data: (items) => items.where((m) => m.status.isOpen).length,
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(user != null ? 'Bonjour ${user.firstName}' : 'Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push(AppRoutes.tenantNotifications),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(tenantDashboardProvider.notifier).refresh();
                await ref.read(unreadCountProvider.notifier).refresh();
              },
              child: dashboardState.when(
                loading: () => const SkeletonList(),
                error: (error, stackTrace) => ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.read(tenantDashboardProvider.notifier).refresh(),
                ),
                data: (dashboard) {
                  final lease = dashboard.activeLease;
                  final nextPayment = dashboard.nextPayment;
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (lease == null)
                        AppCard(
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: theme.colorScheme.outline),
                              const SizedBox(width: 12),
                              const Expanded(child: Text("Aucun bail actif pour le moment.")),
                            ],
                          ),
                        )
                      else ...[
                        AppCard(
                          onTap: () => context.push(AppRoutes.tenantLease),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.home_work_outlined, color: theme.colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(lease.property.title,
                                        style: theme.textTheme.titleMedium,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${lease.property.addressLine ?? ''}, ${lease.property.city ?? ''}',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: theme.colorScheme.outline),
                              ),
                              const SizedBox(height: 12),
                              Text('Loyer mensuel', style: theme.textTheme.labelMedium),
                              Text(Formatters.amount(lease.rentAmount),
                                  style: theme.textTheme.headlineSmall),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      AppCard(
                        onTap: () => context.push(AppRoutes.tenantPayments),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.payments_outlined, color: theme.colorScheme.primary),
                                const SizedBox(width: 8),
                                Text('Prochain paiement', style: theme.textTheme.titleMedium),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (nextPayment == null)
                              const Text('Aucun paiement à venir')
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(Formatters.amount(nextPayment.amountDue),
                                          style: theme.textTheme.headlineSmall),
                                      Text(
                                        'Échéance : ${Formatters.relativeDay(nextPayment.dueDate)}',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: theme.colorScheme.outline),
                                      ),
                                    ],
                                  ),
                                  PaymentStatusChip(status: nextPayment.status),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        onTap: () => context.push(AppRoutes.tenantMaintenance),
                        child: Row(
                          children: [
                            Icon(Icons.build_outlined, color: theme.colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Demandes de maintenance', style: theme.textTheme.titleMedium),
                                  Text(
                                    openMaintenanceCount == null
                                        ? '...'
                                        : '$openMaintenanceCount en cours',
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(color: theme.colorScheme.outline),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Actions rapides', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.push(AppRoutes.tenantMaintenanceNew),
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Nouvelle demande'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
