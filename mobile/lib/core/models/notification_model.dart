import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

// ignore_for_file: constant_identifier_names

enum NotificationType {
  RAPPEL_LOYER,
  RETARD_PAIEMENT,
  CONFIRMATION_PAIEMENT,
  EXPIRATION_CONTRAT,
  MAINTENANCE,
  ALERTE_ADMIN,
}

enum NotificationChannel { IN_APP, EMAIL, SMS }

extension NotificationTypeLabel on NotificationType {
  String get label => switch (this) {
        NotificationType.RAPPEL_LOYER => 'Rappel de loyer',
        NotificationType.RETARD_PAIEMENT => 'Retard de paiement',
        NotificationType.CONFIRMATION_PAIEMENT => 'Paiement confirmé',
        NotificationType.EXPIRATION_CONTRAT => 'Expiration de contrat',
        NotificationType.MAINTENANCE => 'Maintenance',
        NotificationType.ALERTE_ADMIN => 'Alerte',
      };
}

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String organizationId,
    required String userId,
    required NotificationType type,
    required NotificationChannel channel,
    required String title,
    required String message,
    required bool isRead,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
