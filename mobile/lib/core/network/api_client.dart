import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../constants/app_constants.dart';
import '../storage/secure_storage_service.dart';
import 'auth_event_bus.dart';

/// Central Dio-based HTTP client.
///
/// Responsibilities:
/// - attaches `Authorization: Bearer <accessToken>` to every request,
/// - on a 401 (other than from `/auth/login` or `/auth/refresh` themselves),
///   attempts exactly one refresh-and-retry via the manually-managed
///   `refreshToken` cookie, then retries the original request,
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

    // Separate, interceptor-free Dio used only for refresh calls, so the
    // refresh request itself never re-enters the auth interceptor below.
    _refreshDio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

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
      final response = await retryDio.fetch(retryOptions);
      handler.resolve(response);
    } catch (refreshError) {
      _logger.w('Token refresh failed', error: refreshError);
      await _handleRefreshFailure();
      handler.next(err);
    }
  }

  Future<bool> _refreshAccessToken() async {
    final cookie = await _secureStorage.readRefreshCookie();
    if (cookie == null || cookie.isEmpty) {
      return false;
    }

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        options: Options(headers: {'Cookie': cookie}),
      );

      final data = response.data;
      if (data == null || data['accessToken'] == null) {
        return false;
      }

      await _secureStorage.saveAccessToken(data['accessToken'] as String);

      final setCookie = response.headers.map['set-cookie'];
      final newCookie = SecureStorageService.extractRefreshCookie(setCookie);
      if (newCookie != null) {
        await _secureStorage.saveRefreshCookie(newCookie);
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
