import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_model.freezed.dart';
part 'maintenance_model.g.dart';

// ignore_for_file: constant_identifier_names

enum MaintenancePriority { BASSE, NORMALE, HAUTE, URGENTE }

/// Real backend enum - 6 states.
enum MaintenanceStatus { NOUVELLE, VALIDEE, ASSIGNEE, EN_COURS, TERMINEE, CLOTUREE }

enum AttachmentPhase { AVANT, APRES }

extension MaintenancePriorityLabel on MaintenancePriority {
  String get label => switch (this) {
        MaintenancePriority.BASSE => 'Basse',
        MaintenancePriority.NORMALE => 'Normale',
        MaintenancePriority.HAUTE => 'Haute',
        MaintenancePriority.URGENTE => 'Urgente',
      };
}

extension MaintenanceStatusLabel on MaintenanceStatus {
  String get label => switch (this) {
        MaintenanceStatus.NOUVELLE => 'Nouvelle',
        MaintenanceStatus.VALIDEE => 'Validée',
        MaintenanceStatus.ASSIGNEE => 'Assignée',
        MaintenanceStatus.EN_COURS => 'En cours',
        MaintenanceStatus.TERMINEE => 'Terminée',
        MaintenanceStatus.CLOTUREE => 'Clôturée',
      };

  int get stepIndex => MaintenanceStatus.values.indexOf(this);

  /// True while the request is still actively being worked (not finished or
  /// archived) - used for "open requests" counts on dashboards.
  bool get isOpen =>
      this != MaintenanceStatus.TERMINEE && this != MaintenanceStatus.CLOTUREE;
}

/// Minimal tenant summary embedded in maintenance payloads.
@freezed
class TenantSummaryModel with _$TenantSummaryModel {
  const factory TenantSummaryModel({
    required String id,
    required String fullName,
    String? phone,
  }) = _TenantSummaryModel;

  factory TenantSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$TenantSummaryModelFromJson(json);
}

/// Minimal building summary nested inside [MaintenanceUnitSummaryModel] -
/// matches `MaintenanceMapper.toResponse`'s `propertyUnit.property`, which is
/// only `{id, title}` (no address/lat/lng - those aren't selected by the
/// maintenance mapper, unlike the agent's full `GET /properties/:id`).
@freezed
class MaintenancePropertySummaryModel with _$MaintenancePropertySummaryModel {
  const factory MaintenancePropertySummaryModel({
    required String id,
    required String title,
  }) = _MaintenancePropertySummaryModel;

  factory MaintenancePropertySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenancePropertySummaryModelFromJson(json);
}

/// The unit a maintenance request is attached to, as embedded by
/// `MaintenanceMapper.toResponse`'s `propertyUnit`: {id, reference, label, property}.
@freezed
class MaintenanceUnitSummaryModel with _$MaintenanceUnitSummaryModel {
  const factory MaintenanceUnitSummaryModel({
    required String id,
    required String reference,
    String? label,
    required MaintenancePropertySummaryModel property,
  }) = _MaintenanceUnitSummaryModel;

  factory MaintenanceUnitSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceUnitSummaryModelFromJson(json);
}

extension MaintenanceUnitSummaryModelX on MaintenanceUnitSummaryModel {
  String get displayLabel => label ?? reference;
}

@freezed
class MaintenanceAttachmentModel with _$MaintenanceAttachmentModel {
  const factory MaintenanceAttachmentModel({
    required String id,
    required String url,
    required String phase,
    required DateTime createdAt,
  }) = _MaintenanceAttachmentModel;

  factory MaintenanceAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceAttachmentModelFromJson(json);
}

@freezed
class MaintenanceRequestModel with _$MaintenanceRequestModel {
  const factory MaintenanceRequestModel({
    required String id,
    required String organizationId,
    required String propertyUnitId,
    MaintenanceUnitSummaryModel? propertyUnit,
    String? tenantId,
    TenantSummaryModel? tenant,
    required String category,
    required String description,
    required MaintenancePriority priority,
    required MaintenanceStatus status,
    String? assignedToId,
    num? estimatedCost,
    num? actualCost,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? completedAt,
    List<MaintenanceAttachmentModel>? attachments,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MaintenanceRequestModel;

  factory MaintenanceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceRequestModelFromJson(json);
}
