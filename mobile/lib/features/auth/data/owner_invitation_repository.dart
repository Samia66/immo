import 'package:dio/dio.dart';

import '../../../core/models/owner_invitation_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/secure_storage_service.dart';

/// Public, pre-auth "J'ai reçu une invitation" owner-activation flow -
/// mirrors [InvitationRepository] (the tenant equivalent) but against the
/// `/owners/invitations/...` paths and payload shape, which are NOT
/// identical: the code lives in the request body here (not the URL path) for
/// `accept`, and the preview shape carries the manager's name + org instead
/// of lease/unit info.
class OwnerInvitationRepository {
  OwnerInvitationRepository({required Dio dio, required SecureStorageService secureStorage})
      : _dio = dio,
        _secureStorage = secureStorage;

  final Dio _dio;
  final SecureStorageService _secureStorage;

  Future<OwnerInvitationPreviewModel> preview(String code) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/owners/invitations/$code');
      return OwnerInvitationPreviewModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<UserModel> accept({
    required String code,
    required String contact,
    required String otpCode,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/owners/invitations/accept',
        data: {
          'code': code,
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
