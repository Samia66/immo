// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardPropertyUnitSummaryModelImpl
_$$DashboardPropertyUnitSummaryModelImplFromJson(Map<String, dynamic> json) =>
    _$DashboardPropertyUnitSummaryModelImpl(
      id: json['id'] as String,
      reference: json['reference'] as String,
      label: json['label'] as String?,
      property: LeasePropertySummaryModel.fromJson(
        json['property'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$DashboardPropertyUnitSummaryModelImplToJson(
  _$DashboardPropertyUnitSummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'reference': instance.reference,
  'label': instance.label,
  'property': instance.property,
};

_$ActiveLeaseSummaryModelImpl _$$ActiveLeaseSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActiveLeaseSummaryModelImpl(
  id: json['id'] as String,
  propertyUnit: DashboardPropertyUnitSummaryModel.fromJson(
    json['propertyUnit'] as Map<String, dynamic>,
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
  'propertyUnit': instance.propertyUnit,
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
