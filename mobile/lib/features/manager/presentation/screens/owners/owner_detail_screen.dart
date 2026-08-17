import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/loading_skeleton.dart';
import '../../providers/manager_owner_providers.dart';

/// An owner's info + the properties they own (spec: "détail" screen for the
/// manager's owner portfolio) - `GET /owners/:id`, which (unlike the list
/// endpoint) embeds a `properties` summary list.
class OwnerDetailScreen extends ConsumerWidget {
  const OwnerDetailScreen({super.key, required this.ownerId});

  final String ownerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(managerOwnerDetailProvider(ownerId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Propriétaire')),
      body: detailAsync.when(
        loading: () => const SkeletonList(),
        error: (error, stackTrace) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(managerOwnerDetailProvider(ownerId)),
        ),
        data: (owner) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      owner.fullName.isNotEmpty ? owner.fullName[0].toUpperCase() : '?',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(owner.fullName, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(owner.phone, style: theme.textTheme.bodySmall),
                        if (owner.email != null)
                          Text(owner.email!,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: theme.colorScheme.outline)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.apartment_outlined, color: theme.colorScheme.primary),
                        const SizedBox(height: 6),
                        Text('${owner.propertiesCount ?? 0}', style: theme.textTheme.headlineSmall),
                        Text('Biens',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.outline)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.payments_outlined, color: theme.colorScheme.primary),
                        const SizedBox(height: 6),
                        Text(Formatters.amount(owner.totalRevenue ?? 0),
                            style: theme.textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                        Text('Revenu total',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.outline)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Biens', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            if (owner.properties == null || owner.properties!.isEmpty)
              Text('Aucun bien enregistré pour ce propriétaire.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline))
            else
              for (final property in owner.properties!)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    onTap: () => context.push(AppRoutes.managerPropertyDetailPath(property.id)),
                    child: Row(
                      children: [
                        Icon(Icons.apartment_outlined, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(property.title, style: theme.textTheme.titleSmall),
                              Text('${property.reference} · ${property.unitsCount} lot(s)',
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: theme.colorScheme.outline)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: theme.colorScheme.outline),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
