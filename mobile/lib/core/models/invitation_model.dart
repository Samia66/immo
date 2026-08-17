import 'package:freezed_annotation/freezed_annotation.dart';

part 'invitation_model.freezed.dart';
part 'invitation_model.g.dart';

/// Public, pre-auth preview of a tenant activation invitation - returned by
/// `GET /invitations/:code`. Deliberately minimal/non-sensitive (see the
/// backend's `InvitationsService.preview()` doc comment).
@freezed
class InvitationPreviewModel with _$InvitationPreviewModel {
  const factory InvitationPreviewModel({
    required String leaseReference,
    required String unitLabel,
    required String propertyTitle,
    required String organizationName,
    required DateTime expiresAt,
  }) = _InvitationPreviewModel;

  factory InvitationPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$InvitationPreviewModelFromJson(json);
}
