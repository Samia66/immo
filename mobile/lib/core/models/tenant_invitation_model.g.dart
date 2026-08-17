// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_invitation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantInvitationModelImpl _$$TenantInvitationModelImplFromJson(
  Map<String, dynamic> json,
) => _$TenantInvitationModelImpl(
  id: json['id'] as String,
  organizationId: json['organizationId'] as String,
  leaseId: json['leaseId'] as String,
  leaseReference: json['leaseReference'] as String,
  code: json['code'] as String,
  status: $enumDecode(_$TenantInvitationStatusEnumMap, json['status']),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  shareMessage: json['shareMessage'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$TenantInvitationModelImplToJson(
  _$TenantInvitationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'organizationId': instance.organizationId,
  'leaseId': instance.leaseId,
  'leaseReference': instance.leaseReference,
  'code': instance.code,
  'status': _$TenantInvitationStatusEnumMap[instance.status]!,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'shareMessage': instance.shareMessage,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$TenantInvitationStatusEnumMap = {
  TenantInvitationStatus.PENDING: 'PENDING',
  TenantInvitationStatus.ACCEPTED: 'ACCEPTED',
  TenantInvitationStatus.EXPIRED: 'EXPIRED',
  TenantInvitationStatus.REVOKED: 'REVOKED',
};
