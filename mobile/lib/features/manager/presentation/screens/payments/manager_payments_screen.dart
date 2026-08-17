import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/payment_model.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import '../../../../../shared/widgets/refreshable_list_view.dart';
import '../../../../../shared/widgets/status_chip.dart';
import '../../providers/manager_providers.dart';
import 'record_payment_sheet.dart';

/// Manager (GESTIONNAIRE) payments tracking: `GET /payments`, scoped
/// server-side to this manager's own leases. Overdue/pending payments are
/// visually highlighted and offer a "record payment" action.
class ManagerPaymentsScreen extends ConsumerWidget {
  const ManagerPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(managerPaymentsListProvider);
    final notifier = ref.read(managerPaymentsListProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Paiements')),
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
                  ChoiceChip(
                    label: const Text('Tous'),
                    selected: notifier.statusFilter == null,
                    onSelected: (_) => notifier.setStatusFilter(null),
                  ),
                  for (final status in PaymentStatus.values) ...[
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(status.label),
                      selected: notifier.statusFilter == status,
                      onSelected: (_) => notifier.setStatusFilter(status),
                    ),
                  ],
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
              child: RefreshableListView<PaymentModel>(
                value: listState,
                onRefresh: notifier.refresh,
                emptyIcon: Icons.payments_outlined,
                emptyTitle: 'Aucun paiement',
                itemBuilder: (context, payment) {
                  final isOverdue = payment.status == PaymentStatus.EN_RETARD;
                  final isPending =
                      payment.status == PaymentStatus.EN_ATTENTE || payment.status == PaymentStatus.PARTIEL;
                  return AppCard(
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isOverdue
                                ? Colors.red
                                : (isPending ? Colors.orange : Colors.transparent),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Formatters.amount(payment.amountDue),
                                  style: theme.textTheme.titleSmall),
                              Text(
                                'Échéance ${Formatters.date(payment.dueDate)}',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: theme.colorScheme.outline),
                              ),
                              if (payment.balanceDue > 0)
                                Text('Solde ${Formatters.amount(payment.balanceDue)}',
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(color: theme.colorScheme.error)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PaymentStatusChip(status: payment.status),
                            if (payment.status != PaymentStatus.PAYE &&
                                payment.status != PaymentStatus.ANNULE) ...[
                              const SizedBox(height: 6),
                              TextButton(
                                onPressed: () async {
                                  final recorded = await showModalBottomSheet<bool>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => RecordPaymentSheet(payment: payment),
                                  );
                                  if (recorded == true) notifier.refresh();
                                },
                                child: const Text('Enregistrer'),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
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
