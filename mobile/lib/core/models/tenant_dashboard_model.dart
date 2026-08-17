import 'package:freezed_annotation/freezed_annotation.dart';

import 'lease_model.dart';
import 'payment_model.dart';

part 'tenant_dashboard_model.freezed.dart';
part 'tenant_dashboard_model.g.dart';

/// Property-unit summary embedded specifically in `GET /dashboard/tenant`'s
/// `activeLease.propertyUnit` - `DashboardService.tenantDashboard()` selects
/// {id, reference, label, property: {...}} only, with no `status` field
/// (unlike the full lease mapper's `propertyUnit`, hence a distinct model
/// instead of reusing [PropertyUnitSummaryModel]).
@freezed
class DashboardPropertyUnitSummaryModel with _$DashboardPropertyUnitSummaryModel {
  const factory DashboardPropertyUnitSummaryModel({
    required String id,
    required String reference,
    String? label,
    required LeasePropertySummaryModel property,
  }) = _DashboardPropertyUnitSummaryModel;

  factory DashboardPropertyUnitSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardPropertyUnitSummaryModelFromJson(json);
}

extension DashboardPropertyUnitSummaryModelX on DashboardPropertyUnitSummaryModel {
  String get displayLabel => label ?? reference;
}

/// Lightweight lease summary embedded in `GET /dashboard/tenant`'s
/// `activeLease` - a reduced projection (id/propertyUnit/startDate/endDate/rentAmount),
/// distinct from the full LeaseModel returned by `GET /leases/:id`.
@freezed
class ActiveLeaseSummaryModel with _$ActiveLeaseSummaryModel {
  const factory ActiveLeaseSummaryModel({
    required String id,
    required DashboardPropertyUnitSummaryModel propertyUnit,
    required DateTime startDate,
    DateTime? endDate,
    required num rentAmount,
  }) = _ActiveLeaseSummaryModel;

  factory ActiveLeaseSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ActiveLeaseSummaryModelFromJson(json);
}

@freezed
class TenantDashboardModel with _$TenantDashboardModel {
  const factory TenantDashboardModel({
    ActiveLeaseSummaryModel? activeLease,
    PaymentSummaryModel? nextPayment,
    required List<PaymentSummaryModel> recentPayments,
  }) = _TenantDashboardModel;

  factory TenantDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$TenantDashboardModelFromJson(json);
}
