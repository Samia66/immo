import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_invitation_model.freezed.dart';
part 'tenant_invitation_model.g.dart';

// ignore_for_file: constant_identifier_names

/// Real backend enum (`prisma/schema.prisma`'s `TenantInvitationStatus`) -
/// `REVOKED` (not `CANCELLED`) is used when a lease gets a fresh invitation
/// generated, superseding a still-PENDING previous one.
enum TenantInvitationStatus { PENDING, ACCEPTED, EXPIRED, REVOKED }

extension TenantInvitationStatusLabel on TenantInvitationStatus {
  String get label => switch (this) {
        TenantInvitationStatus.PENDING => 'En attente',
        TenantInvitationStatus.ACCEPTED => 'Acceptée',
        TenantInvitationStatus.EXPIRED => 'Expirée',
        TenantInvitationStatus.REVOKED => 'Révoquée',
      };
}

/// Response of `POST /leases/:id/invite` (`TenantInvitationsMapper.toResponse`),
/// generating (or regenerating) the tenant activation invitation for a lease.
@freezed
class TenantInvitationModel with _$TenantInvitationModel {
  const factory TenantInvitationModel({
    required String id,
    required String organizationId,
    required String leaseId,
    required String leaseReference,
    required String code,
    required TenantInvitationStatus status,
    required DateTime expiresAt,
    String? shareMessage,
    required DateTime createdAt,
  }) = _TenantInvitationModel;

  factory TenantInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$TenantInvitationModelFromJson(json);
}
