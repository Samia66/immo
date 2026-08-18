import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/payment_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../data/payment_repository.dart';
import '../providers/tenant_providers.dart';

class PaymentDetailScreen extends ConsumerStatefulWidget {
  const PaymentDetailScreen({super.key, required this.paymentId});

  final String paymentId;

  @override
  ConsumerState<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends ConsumerState<PaymentDetailScreen> {
  bool _downloading = false;

  Future<void> _downloadReceipt() async {
    setState(() => _downloading = true);
    try {
      final result =
          await ref.read(paymentRepositoryProvider).downloadReceipt(widget.paymentId);
      if (!mounted) return;
      switch (result) {
        case ReceiptFileReady(:final filePath):
          // filePath is null on web: the browser's own download UI already
          // handled it, there's nothing left to open here.
          if (filePath == null) break;
          final opened = await launchUrl(Uri.file(filePath));
          if (!mounted) return;
          if (!opened) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Reçu enregistré : $filePath')),
            );
          }
        case ReceiptNotAvailable():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("La quittance n'est pas encore disponible.")),
          );
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(paymentDetailProvider(widget.paymentId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail du paiement')),
      body: detailAsync.when(
        loading: () => const SkeletonList(),
        error: (error, stackTrace) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(paymentDetailProvider(widget.paymentId)),
        ),
        data: (payment) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Formatters.amount(payment.amountDue), style: theme.textTheme.headlineSmall),
                      PaymentStatusChip(status: payment.status),
                    ],
                  ),
                  const Divider(height: 32),
                  _Row(label: 'Montant payé', value: Formatters.amount(payment.amountPaid)),
                  if (payment.balanceDue > 0)
                    _Row(label: 'Solde restant', value: Formatters.amount(payment.balanceDue)),
                  _Row(label: "Date d'échéance", value: Formatters.date(payment.dueDate)),
                  if (payment.paidAt != null)
                    _Row(label: 'Date de paiement', value: Formatters.date(payment.paidAt)),
                  if (payment.lateFee != null && payment.lateFee! > 0)
                    _Row(label: 'Pénalité de retard', value: Formatters.amount(payment.lateFee!)),
                  if (payment.method != null)
                    _Row(label: 'Moyen de paiement', value: payment.method!.label),
                  if (payment.transactionRef != null)
                    _Row(label: 'Référence', value: payment.transactionRef!),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _downloading ? null : _downloadReceipt,
              icon: _downloading
                  ? const SizedBox(
                      width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.receipt_long_outlined),
              label: const Text('Télécharger la quittance'),
            ),
          ],
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
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
