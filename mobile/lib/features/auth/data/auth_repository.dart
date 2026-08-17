import 'package:dio/dio.dart';

import '../../../core/models/user_model.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/secure_storage_service.dart';

/// Talks to `/auth/*`. See the class-level notes in ApiClient for the manual
/// refresh-cookie handling; this repository owns the login/logout/me calls
/// and persists tokens via [SecureStorageService].
class AuthRepository {
  AuthRepository({required Dio dio, required SecureStorageService secureStorage})
      : _dio = dio,
        _secureStorage = secureStorage;

  final Dio _dio;
  final SecureStorageService _secureStorage;

  Future<UserModel> login({required String email, required String password}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return _applyAuthResponse(response);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// `POST /auth/register` - self-service entry point (spec §5.1): creates a
  /// brand-new Organization + a `GESTIONNAIRE` user. `organizationName` is
  /// optional server-side (falls back to "Espace de {firstName} {lastName}"
  /// when omitted/blank). Response shape is identical to [login]'s, so the
  /// session is persisted and applied the same way.
  Future<UserModel> register({
    String? organizationName,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/auth/register', data: {
        if (organizationName != null && organizationName.isNotEmpty)
          'organizationName': organizationName,
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      });
      return _applyAuthResponse(response);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<UserModel> _applyAuthResponse(Response<Map<String, dynamic>> response) async {
    final data = response.data!;
    final accessToken = data['accessToken'] as String;
    await _secureStorage.saveAccessToken(accessToken);

    final setCookie = response.headers.map['set-cookie'];
    final cookie = SecureStorageService.extractRefreshCookie(setCookie);
    if (cookie != null) {
      await _secureStorage.saveRefreshCookie(cookie);
    }

    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      return UserModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {
      // Best-effort: local storage is always cleared regardless below.
    } finally {
      await _secureStorage.clearAll();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post('/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> resetPassword({required String token, required String newPassword}) async {
    try {
      await _dio.post('/auth/reset-password', data: {
        'token': token,
        'newPassword': newPassword,
      });
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<String?> readStoredAccessToken() => _secureStorage.readAccessToken();

  /// `POST /auth/otp/request` - public, triggers a stub-logged 6-digit code
  /// server-side (no real SMS/email delivery yet). `purpose` is one of the
  /// backend's `OtpPurpose` enum values, e.g. `'ACTIVATE_TENANT'`.
  Future<void> requestOtp({required String contact, required String purpose}) async {
    try {
      await _dio.post('/auth/otp/request', data: {'contact': contact, 'purpose': purpose});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// `POST /auth/otp/verify` - a non-consuming dry-run check; the actual
  /// consumption happens inside `POST /invitations/:code/activate`.
  Future<bool> verifyOtp({
    required String contact,
    required String purpose,
    required String code,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/auth/otp/verify', data: {
        'contact': contact,
        'purpose': purpose,
        'code': code,
      });
      return response.data?['valid'] == true;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
