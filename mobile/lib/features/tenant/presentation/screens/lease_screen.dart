import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/lease_model.dart';
import '../../../../core/models/tenant_dashboard_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../providers/tenant_providers.dart';

/// Statuses at which the lease has been sent to the tenant but not yet
/// accepted/refused - this is where "acknowledge on open" + the
/// accept/refuse actions apply.
const _pendingTenantActionStatuses = {LeaseStatus.ENVOYE, LeaseStatus.CONSULTE};

class LeaseScreen extends ConsumerStatefulWidget {
  const LeaseScreen({super.key});

  @override
  ConsumerState<LeaseScreen> createState() => _LeaseScreenState();
}

class _LeaseScreenState extends ConsumerState<LeaseScreen> {
  bool _actioning = false;

  /// Fire-and-forget ENVOYE -> CONSULTE, called once per lease id the first
  /// time this screen sees it in that state - doesn't block the UI, and any
  /// failure is silently ignored (it's a best-effort read-receipt, not a
  /// user-facing action).
  final Set<String> _acknowledgedLeaseIds = {};

  void _maybeAcknowledge(LeaseModel lease) {
    if (lease.status != LeaseStatus.ENVOYE) return;
    if (_acknowledgedLeaseIds.contains(lease.id)) return;
    _acknowledgedLeaseIds.add(lease.id);
    ref.read(leaseRepositoryProvider).acknowledge(lease.id).then((_) {
      if (mounted) ref.invalidate(leaseDetailProvider(lease.id));
    }).catchError((_) {
      // Best-effort - ignore failures.
    });
  }

  Future<void> _accept(LeaseModel lease) async {
    setState(() => _actioning = true);
    try {
      await ref.read(leaseRepositoryProvider).accept(lease.id);
      ref.invalidate(leaseDetailProvider(lease.id));
      await ref.read(tenantDashboardProvider.notifier).refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Contrat accepté.')));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _actioning = false);
    }
  }

  Future<void> _refuse(LeaseModel lease) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => const _RefuseReasonDialog(),
    );
    if (reason == null) return; // Dialog was cancelled.
    setState(() => _actioning = true);
    try {
      await ref.read(leaseRepositoryProvider).refuse(lease.id, reason: reason);
      ref.invalidate(leaseDetailProvider(lease.id));
      await ref.read(tenantDashboardProvider.notifier).refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Contrat refusé.')));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _actioning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              data: (lease) {
                _maybeAcknowledge(lease);
                final unit = lease.propertyUnit;
                final title = unit?.property.title ?? activeLease.propertyUnit.property.title;
                final unitLabel = unit?.displayLabel ?? activeLease.propertyUnit.displayLabel;
                final address = unit != null
                    ? '${unit.property.addressLine}, ${unit.property.city}'
                    : '${activeLease.propertyUnit.property.addressLine}, ${activeLease.propertyUnit.property.city}';
                final showActions = _pendingTenantActionStatuses.contains(lease.status);

                return ListView(
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
                                child: Text(title, style: theme.textTheme.titleLarge),
                              ),
                              LeaseStatusChip(status: lease.status),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${lease.reference} · $unitLabel',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.outline),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            address,
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
                    if (showActions) ...[
                      const SizedBox(height: 20),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: theme.colorScheme.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Ce contrat vous a été envoyé. Merci de le consulter et de répondre.',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _actioning ? null : () => _refuse(lease),
                                    icon: const Icon(Icons.close),
                                    label: const Text('Refuser'),
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor: theme.colorScheme.error),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: _actioning ? null : () => _accept(lease),
                                    icon: _actioning
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.check),
                                    label: const Text('Accepter le contrat'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _RefuseReasonDialog extends StatefulWidget {
  const _RefuseReasonDialog();

  @override
  State<_RefuseReasonDialog> createState() => _RefuseReasonDialogState();
}

class _RefuseReasonDialogState extends State<_RefuseReasonDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Refuser le contrat'),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Motif (facultatif)',
          hintText: 'Expliquez pourquoi vous refusez ce contrat...',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          child: const Text('Confirmer le refus'),
        ),
      ],
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
