import 'dart:async';

/// Minimal pub/sub used by the network layer to signal the auth layer without
/// creating a dependency cycle (the Dio interceptor lives below Riverpod).
///
/// The [AuthInterceptor] fires [forceLogout] when a token refresh
/// conclusively fails (401 on `/auth/refresh`); `AuthNotifier` subscribes and
/// clears session state, which in turn makes the router redirect to login.
class AuthEventBus {
  AuthEventBus._internal();

  static final AuthEventBus instance = AuthEventBus._internal();

  final StreamController<void> _forceLogoutController =
      StreamController<void>.broadcast();

  Stream<void> get onForceLogout => _forceLogoutController.stream;

  void forceLogout() {
    if (!_forceLogoutController.isClosed) {
      _forceLogoutController.add(null);
    }
  }

  void dispose() {
    _forceLogoutController.close();
  }
}
