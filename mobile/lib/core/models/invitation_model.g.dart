// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvitationPreviewModelImpl _$$InvitationPreviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$InvitationPreviewModelImpl(
  leaseReference: json['leaseReference'] as String,
  unitLabel: json['unitLabel'] as String,
  propertyTitle: json['propertyTitle'] as String,
  organizationName: json['organizationName'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$$InvitationPreviewModelImplToJson(
  _$InvitationPreviewModelImpl instance,
) => <String, dynamic>{
  'leaseReference': instance.leaseReference,
  'unitLabel': instance.unitLabel,
  'propertyTitle': instance.propertyTitle,
  'organizationName': instance.organizationName,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
