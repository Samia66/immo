// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManagerDashboardModelImpl _$$ManagerDashboardModelImplFromJson(
  Map<String, dynamic> json,
) => _$ManagerDashboardModelImpl(
  ownersCount: (json['ownersCount'] as num).toInt(),
  propertiesCount: (json['propertiesCount'] as num).toInt(),
  unitsCount: (json['unitsCount'] as num).toInt(),
  unitsByStatus: (json['unitsByStatus'] as List<dynamic>)
      .map((e) => PropertyStatusCount.fromJson(e as Map<String, dynamic>))
      .toList(),
  expectedRent: json['expectedRent'] as num,
  collectedRent: json['collectedRent'] as num,
  pendingCount: (json['pendingCount'] as num).toInt(),
  pendingAmount: json['pendingAmount'] as num,
  overdueCount: (json['overdueCount'] as num).toInt(),
  overdueAmount: json['overdueAmount'] as num,
);

Map<String, dynamic> _$$ManagerDashboardModelImplToJson(
  _$ManagerDashboardModelImpl instance,
) => <String, dynamic>{
  'ownersCount': instance.ownersCount,
  'propertiesCount': instance.propertiesCount,
  'unitsCount': instance.unitsCount,
  'unitsByStatus': instance.unitsByStatus,
  'expectedRent': instance.expectedRent,
  'collectedRent': instance.collectedRent,
  'pendingCount': instance.pendingCount,
  'pendingAmount': instance.pendingAmount,
  'overdueCount': instance.overdueCount,
  'overdueAmount': instance.overdueAmount,
};
