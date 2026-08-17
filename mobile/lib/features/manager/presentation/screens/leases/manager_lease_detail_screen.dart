import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/lease_model.dart';
import '../../../../../core/models/tenant_invitation_model.dart';
import '../../../../../core/network/api_exception.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/loading_skeleton.dart';
import '../../../../../shared/widgets/status_chip.dart';
import '../../providers/manager_lease_providers.dart';

/// Manager-side contract detail: lease info + workflow action buttons
/// matching what's actually valid from the current status. Tenant-only
/// actions (acknowledge/accept/refuse) are intentionally NOT offered here -
/// they stay restricted to the tenant module (spec/task brief).
class ManagerLeaseDetailScreen extends ConsumerStatefulWidget {
  const ManagerLeaseDetailScreen({super.key, required this.leaseId});

  final String leaseId;

  @override
  ConsumerState<ManagerLeaseDetailScreen> createState() => _ManagerLeaseDetailScreenState();
}

class _ManagerLeaseDetailScreenState extends ConsumerState<ManagerLeaseDetailScreen> {
  bool _busy = false;

  Future<void> _run(Future<LeaseModel> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(managerLeaseDetailProvider(widget.leaseId));
      ref.read(managerLeasesListProvider.notifier).refresh();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Une erreur est survenue.')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _send() => _run(() => ref.read(managerLeaseRepositoryProvider).send(widget.leaseId));

  Future<void> _cancel() => _run(() => ref.read(managerLeaseRepositoryProvider).cancel(widget.leaseId));

  Future<void> _terminate() async {
    final result = await _showDatePlusReasonDialog(
      title: 'Résilier le contrat',
      dateLabel: 'Date de résiliation',
      reasonLabel: 'Motif (facultatif)',
    );
    if (result == null) return;
    await _run(() => ref.read(managerLeaseRepositoryProvider).terminate(
          widget.leaseId,
          terminationDate: result.$1,
          reason: result.$2,
        ));
  }

  Future<void> _renew() async {
    final result = await _showDatePlusReasonDialog(
      title: 'Renouveler le contrat',
      dateLabel: 'Nouvelle date de fin',
      reasonLabel: "Description de l'avenant (facultatif)",
    );
    if (result == null) return;
    await _run(() => ref.read(managerLeaseRepositoryProvider).renew(
          widget.leaseId,
          newEndDate: result.$1,
          amendmentDescription: result.$2,
        ));
  }

  Future<(DateTime, String?)?> _showDatePlusReasonDialog({
    required String title,
    required String dateLabel,
    required String reasonLabel,
  }) async {
    DateTime date = DateTime.now();
    final reasonController = TextEditingController();
    final result = await showDialog<(DateTime, String?)>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setDialogState(() => date = picked);
                },
                child: InputDecorator(
                  decoration: InputDecoration(labelText: dateLabel, prefixIcon: const Icon(Icons.event_outlined)),
                  child: Text(Formatters.date(date)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(labelText: reasonLabel),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
            FilledButton(
              onPressed: () => Navigator.of(context).pop((date, reasonController.text.trim())),
              child: const Text('Confirmer'),
            ),
          ],
        ),
      ),
    );
    reasonController.dispose();
    return result;
  }

  Future<void> _invite() async {
    setState(() => _busy = true);
    try {
      final invitation = await ref.read(managerLeaseRepositoryProvider).invite(widget.leaseId);
      if (!mounted) return;
      await _showInvitationResult(invitation);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Une erreur est survenue.')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showInvitationResult(TenantInvitationModel invitation) async {
    final message = invitation.shareMessage ??
        "Vous êtes invité(e) à activer votre compte locataire ImmoSaaS. Code : ${invitation.code}";
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Invitation locataire', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Code', style: Theme.of(context).textTheme.labelLarge),
                    Row(
                      children: [
                        Expanded(
                          child: Text(invitation.code,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(letterSpacing: 1.5)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_outlined),
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: invitation.code));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(content: Text('Code copié.')));
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text(message),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: message));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(content: Text('Message copié.')));
                        }
                      },
                      icon: const Icon(Icons.copy_outlined),
                      label: const Text('Copier le message'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(managerLeaseDetailProvider(widget.leaseId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Contrat')),
      body: detailAsync.when(
        loading: () => const SkeletonList(),
        error: (error, stackTrace) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(managerLeaseDetailProvider(widget.leaseId)),
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
                      Text(lease.reference, style: theme.textTheme.titleLarge),
                      LeaseStatusChip(status: lease.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (lease.propertyUnit != null) ...[
                    _InfoRow(
                      icon: Icons.apartment_outlined,
                      label: 'Bien',
                      value:
                          '${lease.propertyUnit!.property.title} · ${lease.propertyUnit!.displayLabel}',
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (lease.tenant != null) ...[
                    _InfoRow(
                        icon: Icons.person_outline, label: 'Locataire', value: lease.tenant!.fullName),
                    const SizedBox(height: 8),
                  ],
                  _InfoRow(
                    icon: Icons.event_outlined,
                    label: 'Période',
                    value:
                        '${Formatters.date(lease.startDate)} → ${lease.endDate != null ? Formatters.date(lease.endDate) : 'indéterminée'}',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                      icon: Icons.payments_outlined,
                      label: 'Loyer',
                      value:
                          '${Formatters.amount(lease.rentAmount)} · ${lease.paymentFrequency.label}'),
                  const SizedBox(height: 8),
                  _InfoRow(
                      icon: Icons.savings_outlined,
                      label: 'Dépôt de garantie',
                      value: Formatters.amount(lease.depositAmount)),
                  if (lease.indexationRate != null) ...[
                    const SizedBox(height: 8),
                    _InfoRow(
                        icon: Icons.trending_up_outlined,
                        label: 'Indexation',
                        value: '${lease.indexationRate}%'),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Actions', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _actionsFor(lease.status),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _actionsFor(LeaseStatus status) {
    final actions = <Widget>[];
    final canInvite = status != LeaseStatus.ANNULE &&
        status != LeaseStatus.REFUSE &&
        status != LeaseStatus.EXPIRE &&
        status != LeaseStatus.RESILIE;

    if (status == LeaseStatus.BROUILLON) {
      actions.add(FilledButton.icon(
        onPressed: _busy ? null : _send,
        icon: const Icon(Icons.send_outlined),
        label: const Text('Envoyer au locataire'),
      ));
    }
    if (canInvite) {
      actions.add(OutlinedButton.icon(
        onPressed: _busy ? null : _invite,
        icon: const Icon(Icons.mail_outline),
        label: const Text('Inviter le locataire'),
      ));
    }
    if (status == LeaseStatus.ACTIF) {
      actions.add(OutlinedButton.icon(
        onPressed: _busy ? null : _renew,
        icon: const Icon(Icons.autorenew),
        label: const Text('Renouveler'),
      ));
      actions.add(OutlinedButton.icon(
        onPressed: _busy ? null : _terminate,
        icon: const Icon(Icons.event_busy_outlined),
        label: const Text('Résilier'),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.deepOrange),
      ));
    }
    if (status == LeaseStatus.BROUILLON ||
        status == LeaseStatus.ENVOYE ||
        status == LeaseStatus.CONSULTE) {
      actions.add(OutlinedButton.icon(
        onPressed: _busy ? null : _cancel,
        icon: const Icon(Icons.cancel_outlined),
        label: const Text('Annuler'),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
      ));
    }
    return actions;
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.outline),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
