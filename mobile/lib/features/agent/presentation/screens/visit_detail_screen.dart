import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/visit_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../providers/agent_providers.dart';

class VisitDetailScreen extends ConsumerStatefulWidget {
  const VisitDetailScreen({super.key, required this.visitId});

  final String visitId;

  @override
  ConsumerState<VisitDetailScreen> createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends ConsumerState<VisitDetailScreen> {
  bool _submitting = false;

  Future<void> _openCompleteDialog(VisitModel visit) async {
    final outcomeController = TextEditingController();
    var chosenStatus = VisitStatus.REALISEE;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Clôturer la visite'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<VisitStatus>(
                segments: const [
                  ButtonSegment(value: VisitStatus.REALISEE, label: Text('Réalisée')),
                  ButtonSegment(value: VisitStatus.ANNULEE, label: Text('Annulée')),
                ],
                selected: {chosenStatus},
                onSelectionChanged: (selection) =>
                    setDialogState(() => chosenStatus = selection.first),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: outcomeController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Compte-rendu',
                  hintText: 'Retour du client, prochaines étapes...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Annuler')),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Valider'),
            ),
          ],
        ),
      ),
    );

    if (result != true) return;
    setState(() => _submitting = true);
    try {
      await ref.read(visitsRepositoryProvider).complete(
            visit.id,
            status: chosenStatus,
            outcome: outcomeController.text.trim(),
          );
      ref.invalidate(visitDetailProvider(widget.visitId));
      ref.read(visitsListProvider.notifier).refresh();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(visitDetailProvider(widget.visitId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail de la visite')),
      body: detailAsync.when(
        loading: () => const SkeletonList(),
        error: (error, stackTrace) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(visitDetailProvider(widget.visitId)),
        ),
        data: (visit) => RefreshIndicator(
          onRefresh: () => ref.refresh(visitDetailProvider(widget.visitId).future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(visit.clientName, style: theme.textTheme.titleLarge)),
                        VisitStatusChip(status: visit.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _Row(label: 'Date', value: Formatters.dateTime(visit.scheduledAt)),
                    if (visit.clientPhone != null)
                      _Row(label: 'Téléphone', value: visit.clientPhone!),
                    if (visit.clientEmail != null) _Row(label: 'Email', value: visit.clientEmail!),
                    if (visit.notes != null && visit.notes!.isNotEmpty) ...[
                      const Divider(height: 24),
                      Text('Notes', style: theme.textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(visit.notes!),
                    ],
                    if (visit.outcome != null && visit.outcome!.isNotEmpty) ...[
                      const Divider(height: 24),
                      Text('Compte-rendu', style: theme.textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(visit.outcome!),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (visit.clientPhone != null)
                OutlinedButton.icon(
                  onPressed: () => launchUrl(Uri(scheme: 'tel', path: visit.clientPhone)),
                  icon: const Icon(Icons.call_outlined),
                  label: const Text('Appeler le client'),
                ),
              if (visit.status == VisitStatus.PLANIFIEE) ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _submitting ? null : () => _openCompleteDialog(visit),
                  icon: _submitting
                      ? const SizedBox(
                          width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.check_circle_outline),
                  label: const Text('Clôturer la visite'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

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
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
