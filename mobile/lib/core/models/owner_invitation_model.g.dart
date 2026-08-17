// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_invitation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OwnerInvitationModelImpl _$$OwnerInvitationModelImplFromJson(
  Map<String, dynamic> json,
) => _$OwnerInvitationModelImpl(
  id: json['id'] as String,
  organizationId: json['organizationId'] as String,
  managerId: json['managerId'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  code: json['code'] as String,
  status: $enumDecode(_$OwnerInvitationStatusEnumMap, json['status']),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  acceptedAt: json['acceptedAt'] == null
      ? null
      : DateTime.parse(json['acceptedAt'] as String),
  ownerId: json['ownerId'] as String?,
  shareMessage: json['shareMessage'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$OwnerInvitationModelImplToJson(
  _$OwnerInvitationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'organizationId': instance.organizationId,
  'managerId': instance.managerId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'code': instance.code,
  'status': _$OwnerInvitationStatusEnumMap[instance.status]!,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'acceptedAt': instance.acceptedAt?.toIso8601String(),
  'ownerId': instance.ownerId,
  'shareMessage': instance.shareMessage,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$OwnerInvitationStatusEnumMap = {
  OwnerInvitationStatus.PENDING: 'PENDING',
  OwnerInvitationStatus.ACCEPTED: 'ACCEPTED',
  OwnerInvitationStatus.EXPIRED: 'EXPIRED',
  OwnerInvitationStatus.CANCELLED: 'CANCELLED',
};

_$OwnerInvitationPreviewModelImpl _$$OwnerInvitationPreviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$OwnerInvitationPreviewModelImpl(
  managerFirstName: json['managerFirstName'] as String,
  managerLastName: json['managerLastName'] as String,
  organizationName: json['organizationName'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$$OwnerInvitationPreviewModelImplToJson(
  _$OwnerInvitationPreviewModelImpl instance,
) => <String, dynamic>{
  'managerFirstName': instance.managerFirstName,
  'managerLastName': instance.managerLastName,
  'organizationName': instance.organizationName,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
