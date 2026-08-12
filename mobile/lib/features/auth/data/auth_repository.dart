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
}
