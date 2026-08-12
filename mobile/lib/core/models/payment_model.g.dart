// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      leaseId: json['leaseId'] as String,
      amountDue: json['amountDue'] as num,
      amountPaid: json['amountPaid'] as num,
      dueDate: DateTime.parse(json['dueDate'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      lateFee: json['lateFee'] as num?,
      method: $enumDecodeNullable(_$PaymentMethodEnumMap, json['method']),
      transactionRef: json['transactionRef'] as String?,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      receiptUrl: json['receiptUrl'] as String?,
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leaseId': instance.leaseId,
      'amountDue': instance.amountDue,
      'amountPaid': instance.amountPaid,
      'dueDate': instance.dueDate.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'lateFee': instance.lateFee,
      'method': _$PaymentMethodEnumMap[instance.method],
      'transactionRef': instance.transactionRef,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'receiptUrl': instance.receiptUrl,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.ESPECES: 'ESPECES',
  PaymentMethod.VIREMENT: 'VIREMENT',
  PaymentMethod.MOBILE_MONEY: 'MOBILE_MONEY',
  PaymentMethod.CHEQUE: 'CHEQUE',
  PaymentMethod.CARTE: 'CARTE',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.EN_ATTENTE: 'EN_ATTENTE',
  PaymentStatus.PARTIEL: 'PARTIEL',
  PaymentStatus.PAYE: 'PAYE',
  PaymentStatus.EN_RETARD: 'EN_RETARD',
  PaymentStatus.ANNULE: 'ANNULE',
};

_$PaymentSummaryModelImpl _$$PaymentSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentSummaryModelImpl(
  id: json['id'] as String,
  amountDue: json['amountDue'] as num,
  amountPaid: json['amountPaid'] as num,
  dueDate: DateTime.parse(json['dueDate'] as String),
  status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
);

Map<String, dynamic> _$$PaymentSummaryModelImplToJson(
  _$PaymentSummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'amountDue': instance.amountDue,
  'amountPaid': instance.amountPaid,
  'dueDate': instance.dueDate.toIso8601String(),
  'status': _$PaymentStatusEnumMap[instance.status]!,
};
