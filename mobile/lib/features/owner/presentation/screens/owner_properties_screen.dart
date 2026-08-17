import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/property_model.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cached_thumb.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/refreshable_list_view.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../providers/owner_providers.dart';

/// Owner's own properties, each showing its units' occupancy inline (an
/// expandable list under the property title) so a landlord can see what's
/// occupied/available without drilling into every unit individually. Tapping
/// the property opens [OwnerPropertyDetailScreen] for photos/map/full detail.
class OwnerPropertiesScreen extends ConsumerWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(ownerPropertiesListProvider);
    final notifier = ref.read(ownerPropertiesListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes biens')),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels > notification.metrics.maxScrollExtent - 200) {
                  notifier.loadMore();
                }
                return false;
              },
              child: RefreshableListView<PropertyModel>(
                value: listState,
                onRefresh: notifier.refresh,
                emptyIcon: Icons.apartment_outlined,
                emptyTitle: 'Aucun bien',
                emptyMessage: "Vous n'avez pas encore de bien enregistré.",
                itemBuilder: (context, property) => _OwnerPropertyCard(property: property),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerPropertyCard extends StatelessWidget {
  const _OwnerPropertyCard({required this.property});

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final units = property.units ?? const <PropertyUnitModel>[];

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push(AppRoutes.ownerPropertyDetailPath(property.id)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedThumb(
                    relativeUrl: property.coverImage?.url,
                    width: 64,
                    height: 64,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(property.title,
                            style: theme.textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(
                          '${property.city}${property.district != null ? ' - ${property.district}' : ''}',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.outline),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text('${units.length} lot(s) · ${property.availableUnitsCount} disponible(s)',
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          if (units.isNotEmpty) ...[
            const Divider(height: 1),
            for (final unit in units) _UnitRow(unit: unit),
          ],
        ],
      ),
    );
  }
}

class _UnitRow extends StatelessWidget {
  const _UnitRow({required this.unit});

  final PropertyUnitModel unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tenant = unit.currentTenant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(unit.displayLabel, style: theme.textTheme.bodyMedium),
                Text(
                  tenant != null ? tenant.fullName : Formatters.amount(unit.monthlyRent),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),
          ),
          PropertyStatusChip(status: unit.status),
        ],
      ),
    );
  }
}
