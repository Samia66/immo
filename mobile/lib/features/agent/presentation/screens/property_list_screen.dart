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
import '../providers/agent_providers.dart';

/// Read-only property browsing UI shared by the agent and manager modules.
///
/// Defaults to the agent's own list provider and detail route, so existing
/// agent call sites are unaffected. Other roles (e.g. the manager module)
/// can plug in their own paginated list provider, detail-route builder and
/// floating action button (e.g. a permission-gated "add property" FAB)
/// without duplicating the filters/list/empty-state UI below.
class PropertyListScreen extends ConsumerStatefulWidget {
  const PropertyListScreen({
    super.key,
    this.listProvider,
    this.detailPathBuilder,
    this.floatingActionButton,
  });

  final StateNotifierProvider<PropertiesListNotifier, AsyncValue<List<PropertyModel>>>?
      listProvider;
  final String Function(String id)? detailPathBuilder;
  final Widget? floatingActionButton;

  @override
  ConsumerState<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends ConsumerState<PropertyListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveProvider = widget.listProvider ?? propertiesListProvider;
    final detailPathBuilder = widget.detailPathBuilder ?? AppRoutes.agentPropertyDetailPath;
    final listState = ref.watch(effectiveProvider);
    final notifier = ref.read(effectiveProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biens'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher (titre, référence, adresse)...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          notifier.applyFilter(notifier.filter.copyWith(search: ''));
                        },
                      )
                    : null,
              ),
              onSubmitted: (value) =>
                  notifier.applyFilter(notifier.filter.copyWith(search: value)),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _openFilters(context, notifier),
          ),
        ],
      ),
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
                emptyTitle: 'Aucun bien trouvé',
                emptyMessage: 'Essayez de modifier vos filtres de recherche.',
                itemBuilder: (context, item) => AppCard(
                  padding: const EdgeInsets.all(12),
                  onTap: () => context.push(detailPathBuilder(item.id)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedThumb(
                        relativeUrl: item.coverImage?.url,
                        width: 84,
                        height: 84,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title,
                                style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(
                              '${item.city}${item.district != null ? ' - ${item.district}' : ''}',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: theme.colorScheme.outline),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            if (item.minMonthlyRent != null)
                              Text('À partir de ${Formatters.amount(item.minMonthlyRent!)}',
                                  style: theme.textTheme.titleSmall
                                      ?.copyWith(color: theme.colorScheme.primary))
                            else
                              Text('Aucun lot enregistré',
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: theme.colorScheme.outline)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _UnitCountBadge(property: item),
                                const SizedBox(width: 6),
                                Text(item.type.label, style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  void _openFilters(BuildContext context, PropertiesListNotifier notifier) {
    var unitStatus = notifier.filter.unitStatus;
    var type = notifier.filter.type;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filtres', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Text('Statut', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Tous'),
                          selected: unitStatus == null,
                          onSelected: (_) => setModalState(() => unitStatus = null),
                        ),
                        for (final s in PropertyStatus.values)
                          ChoiceChip(
                            label: Text(s.label),
                            selected: unitStatus == s,
                            onSelected: (_) => setModalState(() => unitStatus = s),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Type', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Tous'),
                          selected: type == null,
                          onSelected: (_) => setModalState(() => type = null),
                        ),
                        for (final t in PropertyType.values)
                          ChoiceChip(
                            label: Text(t.label),
                            selected: type == t,
                            onSelected: (_) => setModalState(() => type = t),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {
                        notifier.applyFilter(notifier.filter.copyWith(
                          unitStatus: unitStatus,
                          clearStatus: unitStatus == null,
                          type: type,
                          clearType: type == null,
                        ));
                        Navigator.of(context).pop();
                      },
                      child: const Text('Appliquer'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Compact "X disponible(s) / Y lots" badge for a property list card - the
/// list stays a per-building overview (title/city/photo), with per-unit
/// status/rent detail left to [PropertyDetailScreen].
class _UnitCountBadge extends StatelessWidget {
  const _UnitCountBadge({required this.property});

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final total = property.units?.length ?? 0;
    final available = property.availableUnitsCount;
    return AppStatusChip(
      label: total == 0 ? 'Aucun lot' : '$available/$total dispo.',
      color: available > 0 ? Colors.green : Colors.blueGrey,
      icon: Icons.meeting_room_outlined,
    );
  }
}
