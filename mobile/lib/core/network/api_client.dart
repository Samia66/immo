import 'package:dio/dio.dart';
import 'package:dio/browser.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logger/logger.dart';

import '../constants/app_constants.dart';
import '../storage/secure_storage_service.dart';
import 'auth_event_bus.dart';

/// On Flutter Web, browsers never expose `Set-Cookie` response headers to
/// JavaScript (a platform security restriction, unrelated to CORS or
/// httpOnly) and never let JS set a `Cookie` request header either - so the
/// manual "read Set-Cookie, store it, replay it as a Cookie header" dance
/// this app uses for the refresh-token cookie is a native-only trick that
/// silently no-ops on web. Without `withCredentials`, the browser won't even
/// store/send the httpOnly refresh cookie automatically in its place, so a
/// stale cookie from whichever account first logged in in this browser tab
/// (or none at all) sticks around indefinitely: a later login as a
/// different account never actually rotates it, and the next silent
/// 401-triggered refresh mints a new access token for the *wrong* account.
/// Enabling withCredentials lets the browser manage the httpOnly cookie
/// itself instead - see the web-specific branch in [_AuthInterceptor].
void _enableWebCredentials(Dio dio) {
  if (kIsWeb) {
    dio.httpClientAdapter = BrowserHttpClientAdapter(withCredentials: true);
  }
}

/// Central Dio-based HTTP client.
///
/// Responsibilities:
/// - attaches `Authorization: Bearer <accessToken>` to every request,
/// - on a 401 (other than from `/auth/login` or `/auth/refresh` themselves),
///   attempts exactly one refresh-and-retry - via the manually-managed
///   `refreshToken` cookie on native, or via the browser's own httpOnly
///   cookie jar (`withCredentials`) on web - then retries the original
///   request,
/// - on refresh failure, clears local storage and broadcasts a force-logout
///   event via [AuthEventBus] so the app can route back to login.
class ApiClient {
  ApiClient({required SecureStorageService secureStorage, Logger? logger})
      : _secureStorage = secureStorage,
        _logger = logger ?? Logger(printer: SimplePrinter(colors: false)) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 30),
        headers: const {'Accept': 'application/json'},
      ),
    );
    _enableWebCredentials(_dio);

    // Separate, interceptor-free Dio used only for refresh calls, so the
    // refresh request itself never re-enters the auth interceptor below.
    _refreshDio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
    _enableWebCredentials(_refreshDio);

    _dio.interceptors.add(_AuthInterceptor(
      secureStorage: _secureStorage,
      refreshDio: _refreshDio,
      logger: _logger,
    ));
  }

  final SecureStorageService _secureStorage;
  final Logger _logger;
  late final Dio _dio;
  late final Dio _refreshDio;

  Dio get dio => _dio;
}

class _AuthInterceptor extends QueuedInterceptor {
  _AuthInterceptor({
    required SecureStorageService secureStorage,
    required Dio refreshDio,
    required Logger logger,
  })  : _secureStorage = secureStorage,
        _refreshDio = refreshDio,
        _logger = logger;

  final SecureStorageService _secureStorage;
  final Dio _refreshDio;
  final Logger _logger;

  static const _retriedFlag = 'immo_retried_after_refresh';

  bool _isAuthEndpoint(String path) =>
      path.contains('/auth/login') || path.contains('/auth/refresh');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_isAuthEndpoint(options.path)) {
      final token = await _secureStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    final requestOptions = err.requestOptions;

    final shouldAttemptRefresh = response?.statusCode == 401 &&
        !_isAuthEndpoint(requestOptions.path) &&
        requestOptions.extra[_retriedFlag] != true;

    if (!shouldAttemptRefresh) {
      handler.next(err);
      return;
    }

    try {
      final refreshed = await _refreshAccessToken();
      if (!refreshed) {
        await _handleRefreshFailure();
        handler.next(err);
        return;
      }

      final newToken = await _secureStorage.readAccessToken();
      final retryOptions = requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newToken';
      retryOptions.extra[_retriedFlag] = true;

      final retryDio = Dio(BaseOptions(baseUrl: requestOptions.baseUrl));
      _enableWebCredentials(retryDio);
      final response = await retryDio.fetch(retryOptions);
      handler.resolve(response);
    } catch (refreshError) {
      _logger.w('Token refresh failed', error: refreshError);
      await _handleRefreshFailure();
      handler.next(err);
    }
  }

  Future<bool> _refreshAccessToken() async {
    // On web the browser owns the httpOnly refreshToken cookie entirely - it
    // was never readable to store in the first place, and `withCredentials`
    // (see _enableWebCredentials) makes the browser attach it automatically.
    // Manually setting a `Cookie` header, which the native branch below
    // relies on, is silently ignored by browsers, so there's nothing to read
    // or gate on here.
    String? cookie;
    if (!kIsWeb) {
      cookie = await _secureStorage.readRefreshCookie();
      if (cookie == null || cookie.isEmpty) {
        return false;
      }
    }

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        options: kIsWeb ? null : Options(headers: {'Cookie': cookie}),
      );

      final data = response.data;
      if (data == null || data['accessToken'] == null) {
        return false;
      }

      await _secureStorage.saveAccessToken(data['accessToken'] as String);

      if (!kIsWeb) {
        final setCookie = response.headers.map['set-cookie'];
        final newCookie = SecureStorageService.extractRefreshCookie(setCookie);
        if (newCookie != null) {
          await _secureStorage.saveRefreshCookie(newCookie);
        }
      }
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return false;
      }
      rethrow;
    }
  }

  Future<void> _handleRefreshFailure() async {
    await _secureStorage.clearAll();
    AuthEventBus.instance.forceLogout();
  }
}
