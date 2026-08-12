// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActiveLeaseSummaryModelImpl _$$ActiveLeaseSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActiveLeaseSummaryModelImpl(
  id: json['id'] as String,
  property: PropertySummaryModel.fromJson(
    json['property'] as Map<String, dynamic>,
  ),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  rentAmount: json['rentAmount'] as num,
);

Map<String, dynamic> _$$ActiveLeaseSummaryModelImplToJson(
  _$ActiveLeaseSummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'property': instance.property,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'rentAmount': instance.rentAmount,
};

_$TenantDashboardModelImpl _$$TenantDashboardModelImplFromJson(
  Map<String, dynamic> json,
) => _$TenantDashboardModelImpl(
  activeLease: json['activeLease'] == null
      ? null
      : ActiveLeaseSummaryModel.fromJson(
          json['activeLease'] as Map<String, dynamic>,
        ),
  nextPayment: json['nextPayment'] == null
      ? null
      : PaymentSummaryModel.fromJson(
          json['nextPayment'] as Map<String, dynamic>,
        ),
  recentPayments: (json['recentPayments'] as List<dynamic>)
      .map((e) => PaymentSummaryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$TenantDashboardModelImplToJson(
  _$TenantDashboardModelImpl instance,
) => <String, dynamic>{
  'activeLease': instance.activeLease,
  'nextPayment': instance.nextPayment,
  'recentPayments': instance.recentPayments,
};
