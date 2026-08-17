import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_invitation_model.freezed.dart';
part 'owner_invitation_model.g.dart';

// ignore_for_file: constant_identifier_names

/// Real backend enum (`prisma/schema.prisma`'s `OwnerInvitationStatus`) - note
/// this is NOT the same set of values as `TenantInvitationStatus` (which has
/// `REVOKED` instead of `CANCELLED`).
enum OwnerInvitationStatus { PENDING, ACCEPTED, EXPIRED, CANCELLED }

extension OwnerInvitationStatusLabel on OwnerInvitationStatus {
  String get label => switch (this) {
        OwnerInvitationStatus.PENDING => 'En attente',
        OwnerInvitationStatus.ACCEPTED => 'Acceptée',
        OwnerInvitationStatus.EXPIRED => 'Expirée',
        OwnerInvitationStatus.CANCELLED => 'Annulée',
      };
}

/// A GESTIONNAIRE's sent owner invitation - `POST /owners/invitations`,
/// `GET /owners/invitations` (`OwnerInvitationsMapper.toResponse`).
/// `shareMessage` is only present in the `create()` response, null elsewhere.
@freezed
class OwnerInvitationModel with _$OwnerInvitationModel {
  const factory OwnerInvitationModel({
    required String id,
    required String organizationId,
    required String managerId,
    required String firstName,
    required String lastName,
    String? email,
    String? phone,
    required String code,
    required OwnerInvitationStatus status,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    String? ownerId,
    String? shareMessage,
    required DateTime createdAt,
  }) = _OwnerInvitationModel;

  factory OwnerInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerInvitationModelFromJson(json);
}

/// Public, pre-auth preview of an owner invitation - `GET
/// /owners/invitations/:code` (`OwnerInvitationsService.preview()`).
@freezed
class OwnerInvitationPreviewModel with _$OwnerInvitationPreviewModel {
  const factory OwnerInvitationPreviewModel({
    required String managerFirstName,
    required String managerLastName,
    required String organizationName,
    required DateTime expiresAt,
  }) = _OwnerInvitationPreviewModel;

  factory OwnerInvitationPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerInvitationPreviewModelFromJson(json);
}
