import 'package:flutter/material.dart';

import '../../core/models/lease_model.dart';
import '../../core/models/maintenance_model.dart';
import '../../core/models/payment_model.dart';
import '../../core/models/property_model.dart';
import '../../core/models/visit_model.dart';

/// Generic colored pill chip used for every status/priority label in the app.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentStatusChip extends StatelessWidget {
  const PaymentStatusChip({super.key, required this.status});

  final PaymentStatus status;

  Color _color() => switch (status) {
        PaymentStatus.PAYE => Colors.green,
        PaymentStatus.PARTIEL => Colors.orange,
        PaymentStatus.EN_ATTENTE => Colors.blueGrey,
        PaymentStatus.EN_RETARD => Colors.red,
        PaymentStatus.ANNULE => Colors.grey,
      };

  @override
  Widget build(BuildContext context) =>
      AppStatusChip(label: status.label, color: _color());
}

class MaintenanceStatusChip extends StatelessWidget {
  const MaintenanceStatusChip({super.key, required this.status});

  final MaintenanceStatus status;

  Color _color() => switch (status) {
        MaintenanceStatus.NOUVELLE => Colors.blueGrey,
        MaintenanceStatus.VALIDEE => Colors.indigo,
        MaintenanceStatus.ASSIGNEE => Colors.orange,
        MaintenanceStatus.EN_COURS => Colors.blue,
        MaintenanceStatus.TERMINEE => Colors.green,
        MaintenanceStatus.CLOTUREE => Colors.grey,
      };

  @override
  Widget build(BuildContext context) =>
      AppStatusChip(label: status.label, color: _color());
}

class MaintenancePriorityChip extends StatelessWidget {
  const MaintenancePriorityChip({super.key, required this.priority});

  final MaintenancePriority priority;

  Color _color() => switch (priority) {
        MaintenancePriority.BASSE => Colors.green,
        MaintenancePriority.NORMALE => Colors.blueGrey,
        MaintenancePriority.HAUTE => Colors.orange,
        MaintenancePriority.URGENTE => Colors.red,
      };

  @override
  Widget build(BuildContext context) => AppStatusChip(
        label: priority.label,
        color: _color(),
        icon: priority == MaintenancePriority.URGENTE ? Icons.priority_high : null,
      );
}

class PropertyStatusChip extends StatelessWidget {
  const PropertyStatusChip({super.key, required this.status});

  final PropertyStatus status;

  Color _color() => switch (status) {
        PropertyStatus.DISPONIBLE => Colors.green,
        PropertyStatus.OCCUPE => Colors.blueGrey,
        PropertyStatus.RESERVE => Colors.orange,
        PropertyStatus.MAINTENANCE => Colors.red,
      };

  @override
  Widget build(BuildContext context) =>
      AppStatusChip(label: status.label, color: _color());
}

class VisitStatusChip extends StatelessWidget {
  const VisitStatusChip({super.key, required this.status});

  final VisitStatus status;

  Color _color() => switch (status) {
        VisitStatus.PLANIFIEE => Colors.blue,
        VisitStatus.REALISEE => Colors.green,
        VisitStatus.ANNULEE => Colors.red,
      };

  @override
  Widget build(BuildContext context) =>
      AppStatusChip(label: status.label, color: _color());
}

class LeaseStatusChip extends StatelessWidget {
  const LeaseStatusChip({super.key, required this.status});

  final LeaseStatus status;

  Color _color() => switch (status) {
        LeaseStatus.ACTIF => Colors.green,
        LeaseStatus.EXPIRE => Colors.orange,
        LeaseStatus.RESILIE => Colors.red,
      };

  @override
  Widget build(BuildContext context) =>
      AppStatusChip(label: status.label, color: _color());
}
