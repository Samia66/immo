import 'package:dio/dio.dart';

import '../../../core/models/invitation_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/secure_storage_service.dart';

/// Public, pre-auth "J'ai reçu une invitation" tenant-activation flow:
/// `GET /tenant-invitations/:code` (preview) and
/// `POST /tenant-invitations/:code/activate` (creates the account, logs the
/// tenant in - same response shape as `POST /auth/login`, so this repository
/// persists tokens exactly like [AuthRepository.login] does).
///
/// NOTE: these base paths moved from `/invitations/...` to
/// `/tenant-invitations/...` in the V2 pivot (the old generic `Invitation`
/// model was renamed/split into `TenantInvitation` + `OwnerInvitation`) -
/// see [OwnerInvitationRepository] for the owner-side equivalent.
class InvitationRepository {
  InvitationRepository({required Dio dio, required SecureStorageService secureStorage})
      : _dio = dio,
        _secureStorage = secureStorage;

  final Dio _dio;
  final SecureStorageService _secureStorage;

  Future<InvitationPreviewModel> preview(String code) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/tenant-invitations/$code');
      return InvitationPreviewModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<UserModel> activate({
    required String code,
    required String contact,
    required String otpCode,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/tenant-invitations/$code/activate',
        data: {
          'contact': contact,
          'otpCode': otpCode,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );
      final data = response.data!;
      final accessToken = data['accessToken'] as String;
      await _secureStorage.saveAccessToken(accessToken);

      final setCookie = response.headers.map['set-cookie'];
      final cookie = SecureStorageService.extractRefreshCookie(setCookie);
      if (cookie != null) {
        await _secureStorage.saveRefreshCookie(cookie);
      }

      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
