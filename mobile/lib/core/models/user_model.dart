import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Mirrors `AuthUserDto` returned by `/auth/login`, `/auth/refresh` and
/// `/auth/me`. `roleName` is one of the backend's `RoleName` enum values
/// (French names) - kept as a raw String here and mapped to a [MobileRole]
/// via `mobileRoleFromBackendRole` in app_constants.dart.
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String organizationId,
    required String email,
    required String firstName,
    required String lastName,
    required String roleName,
    required List<String> permissions,
    required bool isEmailVerified,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  String get fullName => '$firstName $lastName';
}

@freezed
class LoginResult with _$LoginResult {
  const factory LoginResult({
    required String accessToken,
    required UserModel user,
  }) = _LoginResult;

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);
}
