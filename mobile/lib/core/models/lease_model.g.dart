// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lease_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertySummaryModelImpl _$$PropertySummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$PropertySummaryModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  reference: json['reference'] as String,
  addressLine: json['addressLine'] as String?,
  city: json['city'] as String?,
);

Map<String, dynamic> _$$PropertySummaryModelImplToJson(
  _$PropertySummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'reference': instance.reference,
  'addressLine': instance.addressLine,
  'city': instance.city,
};

_$LeaseModelImpl _$$LeaseModelImplFromJson(Map<String, dynamic> json) =>
    _$LeaseModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      propertyId: json['propertyId'] as String,
      property: json['property'] == null
          ? null
          : PropertySummaryModel.fromJson(
              json['property'] as Map<String, dynamic>,
            ),
      ownerId: json['ownerId'] as String,
      tenantId: json['tenantId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      rentAmount: json['rentAmount'] as num,
      depositAmount: json['depositAmount'] as num,
      paymentFrequency: $enumDecode(
        _$PaymentFrequencyEnumMap,
        json['paymentFrequency'],
      ),
      indexationRate: (json['indexationRate'] as num?)?.toDouble(),
      status: $enumDecode(_$LeaseStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$LeaseModelImplToJson(_$LeaseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'propertyId': instance.propertyId,
      'property': instance.property,
      'ownerId': instance.ownerId,
      'tenantId': instance.tenantId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'rentAmount': instance.rentAmount,
      'depositAmount': instance.depositAmount,
      'paymentFrequency': _$PaymentFrequencyEnumMap[instance.paymentFrequency]!,
      'indexationRate': instance.indexationRate,
      'status': _$LeaseStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PaymentFrequencyEnumMap = {
  PaymentFrequency.MENSUEL: 'MENSUEL',
  PaymentFrequency.TRIMESTRIEL: 'TRIMESTRIEL',
  PaymentFrequency.SEMESTRIEL: 'SEMESTRIEL',
  PaymentFrequency.ANNUEL: 'ANNUEL',
};

const _$LeaseStatusEnumMap = {
  LeaseStatus.ACTIF: 'ACTIF',
  LeaseStatus.EXPIRE: 'EXPIRE',
  LeaseStatus.RESILIE: 'RESILIE',
};
