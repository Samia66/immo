// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  organizationId: json['organizationId'] as String,
  userId: json['userId'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  channel: $enumDecode(_$NotificationChannelEnumMap, json['channel']),
  title: json['title'] as String,
  message: json['message'] as String,
  isRead: json['isRead'] as bool,
  metadata: json['metadata'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'organizationId': instance.organizationId,
  'userId': instance.userId,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'channel': _$NotificationChannelEnumMap[instance.channel]!,
  'title': instance.title,
  'message': instance.message,
  'isRead': instance.isRead,
  'metadata': instance.metadata,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$NotificationTypeEnumMap = {
  NotificationType.RAPPEL_LOYER: 'RAPPEL_LOYER',
  NotificationType.RETARD_PAIEMENT: 'RETARD_PAIEMENT',
  NotificationType.CONFIRMATION_PAIEMENT: 'CONFIRMATION_PAIEMENT',
  NotificationType.EXPIRATION_CONTRAT: 'EXPIRATION_CONTRAT',
  NotificationType.MAINTENANCE: 'MAINTENANCE',
  NotificationType.ALERTE_ADMIN: 'ALERTE_ADMIN',
};

const _$NotificationChannelEnumMap = {
  NotificationChannel.IN_APP: 'IN_APP',
  NotificationChannel.EMAIL: 'EMAIL',
  NotificationChannel.SMS: 'SMS',
};
