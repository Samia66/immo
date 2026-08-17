import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/property_model.dart';
import '../../core/utils/formatters.dart';
import 'app_card.dart';
import 'status_chip.dart';

/// Read-only card summarizing a single [PropertyUnitModel]: label, status,
/// rent, type/rooms/surface, and - when [showTenant] is true and the unit is
/// occupied - the current tenant's name with a `tel:` call action.
///
/// Shared by the owner module, the agent's property detail screen, and the
/// manager's property/unit detail view - all three need the same
/// "what's this unit's status and who's in it" summary, just wired into
/// different screens.
class UnitStatusCard extends StatelessWidget {
  const UnitStatusCard({super.key, required this.unit, this.showTenant = true});

  final PropertyUnitModel unit;
  final bool showTenant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tenant = unit.currentTenant;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(unit.displayLabel, style: theme.textTheme.titleSmall)),
              PropertyStatusChip(status: unit.status),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              Text(Formatters.amount(unit.monthlyRent), style: theme.textTheme.bodyMedium),
              Text(unit.type.label, style: theme.textTheme.bodySmall),
              if (unit.rooms != null) Text('${unit.rooms} pièces', style: theme.textTheme.bodySmall),
              if (unit.surfaceM2 != null)
                Text('${unit.surfaceM2!.toStringAsFixed(0)} m²', style: theme.textTheme.bodySmall),
            ],
          ),
          if (showTenant && tenant != null) ...[
            const Divider(height: 20),
            Row(
              children: [
                Icon(Icons.person_outline, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(tenant.fullName, style: theme.textTheme.bodyMedium)),
                if (tenant.phone != null)
                  IconButton(
                    icon: const Icon(Icons.call_outlined),
                    onPressed: () => launchUrl(Uri(scheme: 'tel', path: tenant.phone)),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
