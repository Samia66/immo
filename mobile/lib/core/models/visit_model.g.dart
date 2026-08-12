// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitModelImpl _$$VisitModelImplFromJson(Map<String, dynamic> json) =>
    _$VisitModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      propertyId: json['propertyId'] as String,
      agentId: json['agentId'] as String,
      clientName: json['clientName'] as String,
      clientPhone: json['clientPhone'] as String?,
      clientEmail: json['clientEmail'] as String?,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      status: $enumDecode(_$VisitStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      outcome: json['outcome'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VisitModelImplToJson(_$VisitModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'propertyId': instance.propertyId,
      'agentId': instance.agentId,
      'clientName': instance.clientName,
      'clientPhone': instance.clientPhone,
      'clientEmail': instance.clientEmail,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'status': _$VisitStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'outcome': instance.outcome,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$VisitStatusEnumMap = {
  VisitStatus.PLANIFIEE: 'PLANIFIEE',
  VisitStatus.REALISEE: 'REALISEE',
  VisitStatus.ANNULEE: 'ANNULEE',
};
