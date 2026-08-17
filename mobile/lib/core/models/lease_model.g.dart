// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lease_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeasePropertySummaryModelImpl _$$LeasePropertySummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$LeasePropertySummaryModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  reference: json['reference'] as String,
  addressLine: json['addressLine'] as String,
  city: json['city'] as String,
);

Map<String, dynamic> _$$LeasePropertySummaryModelImplToJson(
  _$LeasePropertySummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'reference': instance.reference,
  'addressLine': instance.addressLine,
  'city': instance.city,
};

_$PropertyUnitSummaryModelImpl _$$PropertyUnitSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$PropertyUnitSummaryModelImpl(
  id: json['id'] as String,
  reference: json['reference'] as String,
  label: json['label'] as String?,
  status: $enumDecode(_$PropertyStatusEnumMap, json['status']),
  property: LeasePropertySummaryModel.fromJson(
    json['property'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$PropertyUnitSummaryModelImplToJson(
  _$PropertyUnitSummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'reference': instance.reference,
  'label': instance.label,
  'status': _$PropertyStatusEnumMap[instance.status]!,
  'property': instance.property,
};

const _$PropertyStatusEnumMap = {
  PropertyStatus.DISPONIBLE: 'DISPONIBLE',
  PropertyStatus.OCCUPE: 'OCCUPE',
  PropertyStatus.RESERVE: 'RESERVE',
  PropertyStatus.MAINTENANCE: 'MAINTENANCE',
};

_$LeaseTenantSummaryModelImpl _$$LeaseTenantSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$LeaseTenantSummaryModelImpl(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$$LeaseTenantSummaryModelImplToJson(
  _$LeaseTenantSummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'userId': instance.userId,
};

_$LeaseModelImpl _$$LeaseModelImplFromJson(Map<String, dynamic> json) =>
    _$LeaseModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      reference: json['reference'] as String,
      propertyUnitId: json['propertyUnitId'] as String,
      propertyUnit: json['propertyUnit'] == null
          ? null
          : PropertyUnitSummaryModel.fromJson(
              json['propertyUnit'] as Map<String, dynamic>,
            ),
      ownerId: json['ownerId'] as String,
      managerId: json['managerId'] as String,
      tenantId: json['tenantId'] as String,
      tenant: json['tenant'] == null
          ? null
          : LeaseTenantSummaryModel.fromJson(
              json['tenant'] as Map<String, dynamic>,
            ),
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
      'reference': instance.reference,
      'propertyUnitId': instance.propertyUnitId,
      'propertyUnit': instance.propertyUnit,
      'ownerId': instance.ownerId,
      'managerId': instance.managerId,
      'tenantId': instance.tenantId,
      'tenant': instance.tenant,
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
  LeaseStatus.BROUILLON: 'BROUILLON',
  LeaseStatus.ENVOYE: 'ENVOYE',
  LeaseStatus.CONSULTE: 'CONSULTE',
  LeaseStatus.ACCEPTE: 'ACCEPTE',
  LeaseStatus.ACTIF: 'ACTIF',
  LeaseStatus.REFUSE: 'REFUSE',
  LeaseStatus.ANNULE: 'ANNULE',
  LeaseStatus.EXPIRE: 'EXPIRE',
  LeaseStatus.RESILIE: 'RESILIE',
};
