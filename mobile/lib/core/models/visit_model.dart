import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit_model.freezed.dart';
part 'visit_model.g.dart';

// ignore_for_file: constant_identifier_names

/// New module, added to the backend alongside this mobile app - see the
/// contract in the task brief: same JwtAuthGuard+PermissionsGuard,
/// paginated-list conventions as every other module.
enum VisitStatus { PLANIFIEE, REALISEE, ANNULEE }

extension VisitStatusLabel on VisitStatus {
  String get label => switch (this) {
        VisitStatus.PLANIFIEE => 'Planifiée',
        VisitStatus.REALISEE => 'Réalisée',
        VisitStatus.ANNULEE => 'Annulée',
      };
}

@freezed
class VisitModel with _$VisitModel {
  const factory VisitModel({
    required String id,
    required String organizationId,
    required String propertyId,
    required String agentId,
    required String clientName,
    String? clientPhone,
    String? clientEmail,
    required DateTime scheduledAt,
    required VisitStatus status,
    String? notes,
    String? outcome,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VisitModel;

  factory VisitModel.fromJson(Map<String, dynamic> json) =>
      _$VisitModelFromJson(json);
}
