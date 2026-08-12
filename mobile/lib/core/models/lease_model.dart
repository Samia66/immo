import 'package:freezed_annotation/freezed_annotation.dart';

part 'lease_model.freezed.dart';
part 'lease_model.g.dart';

// ignore_for_file: constant_identifier_names

enum LeaseStatus { ACTIF, EXPIRE, RESILIE }

enum PaymentFrequency { MENSUEL, TRIMESTRIEL, SEMESTRIEL, ANNUEL }

extension LeaseStatusLabel on LeaseStatus {
  String get label => switch (this) {
        LeaseStatus.ACTIF => 'Actif',
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

/// Small property summary embedded in lease/dashboard payloads (not the full
/// PropertyModel).
@freezed
class PropertySummaryModel with _$PropertySummaryModel {
  const factory PropertySummaryModel({
    required String id,
    required String title,
    required String reference,
    String? addressLine,
    String? city,
  }) = _PropertySummaryModel;

  factory PropertySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$PropertySummaryModelFromJson(json);
}

@freezed
class LeaseModel with _$LeaseModel {
  const factory LeaseModel({
    required String id,
    required String organizationId,
    required String propertyId,
    PropertySummaryModel? property,
    required String ownerId,
    required String tenantId,
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
