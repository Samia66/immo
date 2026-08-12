import 'package:freezed_annotation/freezed_annotation.dart';

import 'lease_model.dart';
import 'payment_model.dart';

part 'tenant_dashboard_model.freezed.dart';
part 'tenant_dashboard_model.g.dart';

/// Lightweight lease summary embedded in `GET /dashboard/tenant`'s
/// `activeLease` - a reduced projection (id/property/startDate/endDate/rentAmount),
/// distinct from the full LeaseModel returned by `GET /leases/:id`.
@freezed
class ActiveLeaseSummaryModel with _$ActiveLeaseSummaryModel {
  const factory ActiveLeaseSummaryModel({
    required String id,
    required PropertySummaryModel property,
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
