import 'package:freezed_annotation/freezed_annotation.dart';

import 'property_model.dart';

part 'lease_model.freezed.dart';
part 'lease_model.g.dart';

// ignore_for_file: constant_identifier_names

/// Real backend enum - 9 states covering the full send/acknowledge/accept
/// tenant-activation workflow, not just the terminal ACTIF/EXPIRE/RESILIE.
enum LeaseStatus { BROUILLON, ENVOYE, CONSULTE, ACCEPTE, ACTIF, REFUSE, ANNULE, EXPIRE, RESILIE }

enum PaymentFrequency { MENSUEL, TRIMESTRIEL, SEMESTRIEL, ANNUEL }

extension LeaseStatusLabel on LeaseStatus {
  String get label => switch (this) {
        LeaseStatus.BROUILLON => 'Brouillon',
        LeaseStatus.ENVOYE => 'Envoyé',
        LeaseStatus.CONSULTE => 'Consulté',
        LeaseStatus.ACCEPTE => 'Accepté',
        LeaseStatus.ACTIF => 'Actif',
        LeaseStatus.REFUSE => 'Refusé',
        LeaseStatus.ANNULE => 'Annulé',
        LeaseStatus.EXPIRE => 'Expiré',
        LeaseStatus.RESILIE => 'Résilié',
      };
}

extension PaymentFrequencyLabel on PaymentFrequency {
  String get label => switch (this) {
        PaymentFrequency.MENSUEL => 'Mensuel',
        PaymentFrequency.TRIMESTRIEL => 'Trimestriel',
        PaymentFrequency.SEMESTRIEL => 'Semestriel',
        PaymentFrequency.ANNUEL => 'Annuel',
      };
}

/// Small property summary nested inside [PropertyUnitSummaryModel] - just
/// enough to show the building a unit belongs to (id/title/reference/address/city).
@freezed
class LeasePropertySummaryModel with _$LeasePropertySummaryModel {
  const factory LeasePropertySummaryModel({
    required String id,
    required String title,
    required String reference,
    required String addressLine,
    required String city,
  }) = _LeasePropertySummaryModel;

  factory LeasePropertySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$LeasePropertySummaryModelFromJson(json);
}

/// Small property-unit summary embedded in lease/dashboard payloads (not the
/// full PropertyUnitModel) - matches `Lease.propertyUnit` as mapped by
/// `LeasesMapper.toResponse`: {id, reference, label, status, property: {...}}.
@freezed
class PropertyUnitSummaryModel with _$PropertyUnitSummaryModel {
  const factory PropertyUnitSummaryModel({
    required String id,
    required String reference,
    String? label,
    required PropertyStatus status,
    required LeasePropertySummaryModel property,
  }) = _PropertyUnitSummaryModel;

  factory PropertyUnitSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyUnitSummaryModelFromJson(json);
}

extension PropertyUnitSummaryModelX on PropertyUnitSummaryModel {
  String get displayLabel => label ?? reference;
}

/// Small tenant summary embedded in every lease response
/// (`LeasesRepository.includeRelations.tenant`) - `userId` is null until the
/// tenant has activated their portal account.
@freezed
class LeaseTenantSummaryModel with _$LeaseTenantSummaryModel {
  const factory LeaseTenantSummaryModel({
    required String id,
    required String fullName,
    String? userId,
  }) = _LeaseTenantSummaryModel;

  factory LeaseTenantSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaseTenantSummaryModelFromJson(json);
}

@freezed
class LeaseModel with _$LeaseModel {
  const factory LeaseModel({
    required String id,
    required String organizationId,
    required String reference,
    required String propertyUnitId,
    PropertyUnitSummaryModel? propertyUnit,
    required String ownerId,
    required String managerId,
    required String tenantId,
    LeaseTenantSummaryModel? tenant,
    required DateTime startDate,
    DateTime? endDate,
    required num rentAmount,
    required num depositAmount,
    required PaymentFrequency paymentFrequency,
    double? indexationRate,
    required LeaseStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LeaseModel;

  factory LeaseModel.fromJson(Map<String, dynamic> json) =>
      _$LeaseModelFromJson(json);
}
