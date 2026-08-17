import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as ll;

import '../../../../core/models/property_model.dart';
import '../../../../shared/widgets/cached_thumb.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/unit_status_card.dart';
import '../providers/owner_providers.dart';

/// Read-only property detail for the PROPRIETAIRE portal - reuses the
/// agent's photo-gallery/map/address layout, but replaces the single
/// rent/rooms/surface block (that used to live on Property) with a list of
/// this property's units and their occupancy, since that data now lives on
/// PropertyUnit. Owners don't create/edit here - that stays manager/admin-only.
class OwnerPropertyDetailScreen extends ConsumerWidget {
  const OwnerPropertyDetailScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(ownerPropertyDetailProvider(propertyId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail du bien')),
      body: detailAsync.when(
        loading: () => const SkeletonList(),
        error: (error, stackTrace) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(ownerPropertyDetailProvider(propertyId)),
        ),
        data: (property) => ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            if (property.images != null && property.images!.isNotEmpty)
              SizedBox(
                height: 220,
                child: PageView(
                  children: [
                    for (final image in property.images!)
                      CachedThumb(relativeUrl: image.url, width: double.infinity, height: 220),
                  ],
                ),
              )
            else
              const CachedThumb(relativeUrl: null, width: double.infinity, height: 220),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(property.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    '${property.reference} · ${property.addressLine}, ${property.city}',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
                  const SizedBox(height: 8),
                  Text(property.type.label, style: theme.textTheme.bodyMedium),
                  if (property.description != null && property.description!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text('Description', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Text(property.description!, style: theme.textTheme.bodyMedium),
                  ],
                  if (property.latitude != null && property.longitude != null) ...[
                    const SizedBox(height: 20),
                    Text('Localisation', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 180,
                        child: IgnorePointer(
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: ll.LatLng(property.latitude!, property.longitude!),
                              initialZoom: 15,
                              interactionOptions:
                                  const InteractionOptions(flags: InteractiveFlag.none),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.immosaas.immo_mobile',
                              ),
                              MarkerLayer(markers: [
                                Marker(
                                  point: ll.LatLng(property.latitude!, property.longitude!),
                                  width: 36,
                                  height: 36,
                                  child: Icon(Icons.location_pin,
                                      color: theme.colorScheme.error, size: 36),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text('Lots (${property.units?.length ?? 0})', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  if (property.units == null || property.units!.isEmpty)
                    Text('Aucun lot enregistré pour ce bien.',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.colorScheme.outline))
                  else
                    for (final unit in property.units!)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: UnitStatusCard(unit: unit),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
