import 'package:freezed_annotation/freezed_annotation.dart';

import 'owner_dashboard_model.dart';

part 'manager_dashboard_model.freezed.dart';
part 'manager_dashboard_model.g.dart';

/// GESTIONNAIRE portal dashboard - `GET /dashboard/manager`
/// (`DashboardService.managerDashboard()`). Reuses [PropertyStatusCount] from
/// the owner dashboard model - same `{status, count}` shape, always all 4
/// `PropertyStatus` values.
@freezed
class ManagerDashboardModel with _$ManagerDashboardModel {
  const factory ManagerDashboardModel({
    required int ownersCount,
    required int propertiesCount,
    required int unitsCount,
    required List<PropertyStatusCount> unitsByStatus,
    required num expectedRent,
    required num collectedRent,
    required int pendingCount,
    required num pendingAmount,
    required int overdueCount,
    required num overdueAmount,
  }) = _ManagerDashboardModel;

  factory ManagerDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$ManagerDashboardModelFromJson(json);
}
