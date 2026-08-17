// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantModelImpl _$$TenantModelImplFromJson(Map<String, dynamic> json) =>
    _$TenantModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String?,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      profession: json['profession'] as String?,
      employer: json['employer'] as String?,
      monthlyIncome: json['monthlyIncome'] as num?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TenantModelImplToJson(_$TenantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'userId': instance.userId,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'profession': instance.profession,
      'employer': instance.employer,
      'monthlyIncome': instance.monthlyIncome,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
