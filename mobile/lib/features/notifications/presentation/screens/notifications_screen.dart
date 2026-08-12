import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/notification_model.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/refreshable_list_view.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _iconFor(NotificationType type) => switch (type) {
        NotificationType.RAPPEL_LOYER => Icons.notifications_active_outlined,
        NotificationType.RETARD_PAIEMENT => Icons.warning_amber_outlined,
        NotificationType.CONFIRMATION_PAIEMENT => Icons.check_circle_outline,
        NotificationType.EXPIRATION_CONTRAT => Icons.event_busy_outlined,
        NotificationType.MAINTENANCE => Icons.build_outlined,
        NotificationType.ALERTE_ADMIN => Icons.campaign_outlined,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(notificationsListProvider);
    final notifier = ref.read(notificationsListProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            tooltip: 'Tout marquer comme lu',
            icon: const Icon(Icons.done_all),
            onPressed: () => notifier.markAllRead(),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshableListView<NotificationModel>(
              value: listState,
              onRefresh: notifier.refresh,
              emptyIcon: Icons.notifications_none,
              emptyTitle: 'Aucune notification',
              emptyMessage: 'Vous serez averti ici des événements importants.',
              itemBuilder: (context, item) => AppCard(
                onTap: item.isRead ? null : () => notifier.markRead(item.id),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.isRead
                            ? theme.colorScheme.surfaceContainerHighest
                            : theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _iconFor(item.type),
                        size: 20,
                        color: item.isRead
                            ? theme.colorScheme.outline
                            : theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!item.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(item.message, style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 6),
                          Text(
                            Formatters.dateTime(item.createdAt),
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.outline),
                          ),
                        ],
                      ),
                    ),
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
