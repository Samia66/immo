import 'package:freezed_annotation/freezed_annotation.dart';

import 'property_model.dart';

part 'owner_dashboard_model.freezed.dart';
part 'owner_dashboard_model.g.dart';

/// Unit count for a single [PropertyStatus] value, part of `GET
/// /dashboard/owner`'s `byStatus` (always includes all 4 statuses, even at 0).
@freezed
class PropertyStatusCount with _$PropertyStatusCount {
  const factory PropertyStatusCount({
    required PropertyStatus status,
    required int count,
  }) = _PropertyStatusCount;

  factory PropertyStatusCount.fromJson(Map<String, dynamic> json) =>
      _$PropertyStatusCountFromJson(json);
}

/// PROPRIETAIRE portal dashboard - `GET /dashboard/owner`.
@freezed
class OwnerDashboardModel with _$OwnerDashboardModel {
  const factory OwnerDashboardModel({
    required int totalUnits,
    required List<PropertyStatusCount> byStatus,
    required num monthlyRevenue,
    required int pendingCount,
    required num pendingAmount,
    required int overdueCount,
    required num overdueAmount,
  }) = _OwnerDashboardModel;

  factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerDashboardModelFromJson(json);
}
