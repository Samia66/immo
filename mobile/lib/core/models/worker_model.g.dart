// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkerModelImpl _$$WorkerModelImplFromJson(Map<String, dynamic> json) =>
    _$WorkerModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      fullName: json['fullName'] as String,
      trade: json['trade'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool,
      propertyId: json['propertyId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorkerModelImplToJson(_$WorkerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'fullName': instance.fullName,
      'trade': instance.trade,
      'phone': instance.phone,
      'email': instance.email,
      'notes': instance.notes,
      'isActive': instance.isActive,
      'propertyId': instance.propertyId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
