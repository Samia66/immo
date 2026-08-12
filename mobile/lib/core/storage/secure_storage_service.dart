import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Wraps [FlutterSecureStorage] for the small set of secrets the app persists:
/// the JWT access token (kept only in memory ideally, but persisted so the
/// splash screen can attempt a silent resume) and the raw `refreshToken=...`
/// cookie string used to manually replay the httpOnly cookie on `/auth/refresh`.
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: StorageKeys.accessToken, value: token);

  Future<String?> readAccessToken() =>
      _storage.read(key: StorageKeys.accessToken);

  Future<void> saveRefreshCookie(String rawCookieValue) =>
      _storage.write(key: StorageKeys.refreshTokenCookie, value: rawCookieValue);

  Future<String?> readRefreshCookie() =>
      _storage.read(key: StorageKeys.refreshTokenCookie);

  Future<void> clearAll() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshTokenCookie);
  }

  /// Extracts the `refreshToken=<value>` segment from a raw `set-cookie`
  /// header value (there may be multiple cookies / attributes separated by
  /// `;` and, when Dio surfaces multiple Set-Cookie headers, multiple entries
  /// in a list). Returns null if no refreshToken cookie is present.
  static String? extractRefreshCookie(List<String>? setCookieHeaders) {
    if (setCookieHeaders == null) return null;
    for (final header in setCookieHeaders) {
      final segments = header.split(';');
      for (final segment in segments) {
        final trimmed = segment.trim();
        if (trimmed.startsWith('refreshToken=')) {
          return trimmed;
        }
      }
    }
    return null;
  }
}
