// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyStatusCountImpl _$$PropertyStatusCountImplFromJson(
  Map<String, dynamic> json,
) => _$PropertyStatusCountImpl(
  status: $enumDecode(_$PropertyStatusEnumMap, json['status']),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$PropertyStatusCountImplToJson(
  _$PropertyStatusCountImpl instance,
) => <String, dynamic>{
  'status': _$PropertyStatusEnumMap[instance.status]!,
  'count': instance.count,
};

const _$PropertyStatusEnumMap = {
  PropertyStatus.DISPONIBLE: 'DISPONIBLE',
  PropertyStatus.OCCUPE: 'OCCUPE',
  PropertyStatus.RESERVE: 'RESERVE',
  PropertyStatus.MAINTENANCE: 'MAINTENANCE',
};

_$OwnerDashboardModelImpl _$$OwnerDashboardModelImplFromJson(
  Map<String, dynamic> json,
) => _$OwnerDashboardModelImpl(
  totalUnits: (json['totalUnits'] as num).toInt(),
  byStatus: (json['byStatus'] as List<dynamic>)
      .map((e) => PropertyStatusCount.fromJson(e as Map<String, dynamic>))
      .toList(),
  monthlyRevenue: json['monthlyRevenue'] as num,
  pendingCount: (json['pendingCount'] as num).toInt(),
  pendingAmount: json['pendingAmount'] as num,
  overdueCount: (json['overdueCount'] as num).toInt(),
  overdueAmount: json['overdueAmount'] as num,
);

Map<String, dynamic> _$$OwnerDashboardModelImplToJson(
  _$OwnerDashboardModelImpl instance,
) => <String, dynamic>{
  'totalUnits': instance.totalUnits,
  'byStatus': instance.byStatus,
  'monthlyRevenue': instance.monthlyRevenue,
  'pendingCount': instance.pendingCount,
  'pendingAmount': instance.pendingAmount,
  'overdueCount': instance.overdueCount,
  'overdueAmount': instance.overdueAmount,
};
