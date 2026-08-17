import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_model.freezed.dart';
part 'tenant_model.g.dart';

/// A tenant record (as distinct from a `LOCATAIRE` portal user account) -
/// `GET /tenants`, `GET /tenants/:id`, `POST /tenants`
/// (`TenantsMapper.toResponse`). `userId` is only set once the tenant has
/// activated their portal account via a `TenantInvitation`.
@freezed
class TenantModel with _$TenantModel {
  const factory TenantModel({
    required String id,
    required String organizationId,
    String? userId,
    required String fullName,
    required String phone,
    String? email,
    String? profession,
    String? employer,
    num? monthlyIncome,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TenantModel;

  factory TenantModel.fromJson(Map<String, dynamic> json) =>
      _$TenantModelFromJson(json);
}
