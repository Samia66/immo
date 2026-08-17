import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as ll;

import '../../../../core/models/payment_model.dart';
import '../../../../core/models/property_model.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cached_thumb.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/unit_status_card.dart';
import '../../../agent/presentation/providers/agent_providers.dart';
import '../providers/manager_providers.dart';

/// Manager-side property detail: photo gallery / address / map (same layout
/// as the agent's), plus - per occupied unit - the current tenant's contact
/// (via [UnitStatusCard]'s call action) and a payments summary (pending,
/// overdue, recent payments), queried per-unit since `QueryPaymentDto` only
/// filters by `propertyUnitId`, not a property-level id.
class ManagerPropertyDetailScreen extends ConsumerWidget {
  const ManagerPropertyDetailScreen({super.key, required this.propertyId});

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
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UnitStatusCard(unit: unit),
                            if (unit.status == PropertyStatus.OCCUPE) ...[
                              const SizedBox(height: 8),
                              _UnitPaymentsSummary(unitId: unit.id),
                            ],
                          ],
                        ),
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

class _UnitPaymentsSummary extends ConsumerWidget {
  const _UnitPaymentsSummary({required this.unitId});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(unitPaymentsProvider(unitId));
    final theme = Theme.of(context);

    return paymentsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: SizedBox(
          width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
      ),
      error: (error, stackTrace) => Text(
        'Paiements indisponibles',
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
      ),
      data: (payments) {
        if (payments.isEmpty) {
          return Text('Aucun paiement enregistré pour ce lot.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline));
        }
        final pending = payments.where(
            (p) => p.status == PaymentStatus.EN_ATTENTE || p.status == PaymentStatus.PARTIEL);
        final overdue = payments.where((p) => p.status == PaymentStatus.EN_RETARD);
        final pendingAmount = pending.fold<num>(0, (sum, p) => sum + p.balanceDue);
        final overdueAmount = overdue.fold<num>(0, (sum, p) => sum + p.balanceDue);
        final recent = payments.take(3).toList();

        return AppCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.payments_outlined, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text('Paiements', style: theme.textTheme.labelLarge),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'En attente',
                      count: pending.length,
                      amount: pendingAmount,
                      color: Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _MiniStat(
                      label: 'En retard',
                      count: overdue.length,
                      amount: overdueAmount,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              for (final payment in recent)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${Formatters.amount(payment.amountDue)} · ${Formatters.date(payment.dueDate)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      PaymentStatusChip(status: payment.status),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.count,
    required this.amount,
    required this.color,
  });

  final String label;
  final int count;
  final num amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$count', style: theme.textTheme.titleMedium?.copyWith(color: color)),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
        Text(Formatters.amount(amount), style: theme.textTheme.bodySmall),
      ],
    );
  }
}
