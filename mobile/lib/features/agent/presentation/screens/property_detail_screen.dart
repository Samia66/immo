import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/owner_model.dart';
import '../../../../core/models/property_model.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cached_thumb.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../providers/agent_providers.dart';

class PropertyDetailScreen extends ConsumerWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(propertyDetailProvider(propertyId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail du bien')),
      body: detailAsync.when(
        loading: () => const SkeletonList(),
        error: (error, stackTrace) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(propertyDetailProvider(propertyId)),
        ),
        data: (property) => ListView(
          padding: const EdgeInsets.only(bottom: 100),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(property.title, style: theme.textTheme.headlineSmall)),
                      PropertyStatusChip(status: property.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${property.reference} · ${property.addressLine}, ${property.city}',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
                  const SizedBox(height: 16),
                  Text(Formatters.amount(property.monthlyRent), style: theme.textTheme.headlineMedium),
                  if (property.monthlyCharges != null)
                    Text(
                      '+ ${Formatters.amount(property.monthlyCharges!)} de charges',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                    ),
                  const SizedBox(height: 20),
                  AppCard(
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children: [
                        _Characteristic(icon: Icons.category_outlined, label: property.type.label),
                        if (property.rooms != null)
                          _Characteristic(
                              icon: Icons.meeting_room_outlined, label: '${property.rooms} pièces'),
                        if (property.surfaceM2 != null)
                          _Characteristic(
                              icon: Icons.square_foot_outlined,
                              label: '${property.surfaceM2!.toStringAsFixed(0)} m²'),
                      ],
                    ),
                  ),
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
                                // Public OpenStreetMap tile server - no API key required.
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
                  const SizedBox(height: 20),
                  Text('Propriétaire', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, ref, _) {
                      final ownerAsync = ref.watch(ownerDetailProvider(property.ownerId));
                      return ownerAsync.when(
                        loading: () => const SkeletonListTile(),
                        error: (error, stackTrace) => AppCard(
                          child: Text('Impossible de charger le propriétaire',
                              style: theme.textTheme.bodySmall),
                        ),
                        data: (owner) => _OwnerCard(owner: owner),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: detailAsync.maybeWhen(
        data: (property) => FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.agentVisitNew, extra: property.id),
          icon: const Icon(Icons.event_available_outlined),
          label: const Text('Planifier une visite'),
        ),
        orElse: () => null,
      ),
    );
  }
}

class _Characteristic extends StatelessWidget {
  const _Characteristic({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.owner});

  final OwnerModel owner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(owner.fullName.isNotEmpty ? owner.fullName[0].toUpperCase() : '?'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(owner.fullName, style: theme.textTheme.titleSmall),
                Text(owner.phone, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () => launchUrl(Uri(scheme: 'tel', path: owner.phone)),
          ),
        ],
      ),
    );
  }
}
