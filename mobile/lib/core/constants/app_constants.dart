/// App-wide constants and runtime configuration.
///
/// The API base URL defaults to the Android emulator loopback alias
/// (`10.0.2.2`), which maps to the host machine's `localhost`. Override at
/// build/run time with:
///   flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
/// (useful for iOS simulator / web / a physical device on the same LAN).
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api',
  );

  /// The API is mounted under `/api`. File/image URLs returned by the API
  /// (e.g. `property.images[].url`) are relative paths rooted at the server
  /// root, not under `/api` - so we strip the trailing `/api` to get the
  /// server root used to resolve those relative paths.
  static String get serverRoot {
    if (apiBaseUrl.endsWith('/api')) {
      return apiBaseUrl.substring(0, apiBaseUrl.length - 4);
    }
    return apiBaseUrl;
  }

  static String resolveFileUrl(String? relativeOrAbsoluteUrl) {
    if (relativeOrAbsoluteUrl == null || relativeOrAbsoluteUrl.isEmpty) {
      return '';
    }
    if (relativeOrAbsoluteUrl.startsWith('http://') ||
        relativeOrAbsoluteUrl.startsWith('https://')) {
      return relativeOrAbsoluteUrl;
    }
    final path = relativeOrAbsoluteUrl.startsWith('/')
        ? relativeOrAbsoluteUrl
        : '/$relativeOrAbsoluteUrl';
    return '$serverRoot$path';
  }
}

class AppRoles {
  AppRoles._();

  static const String superAdmin = 'SUPER_ADMIN';
  static const String adminAgence = 'ADMIN_AGENCE';
  static const String gestionnaire = 'GESTIONNAIRE';
  static const String agentImmobilier = 'AGENT_IMMOBILIER';
  static const String locataire = 'LOCATAIRE';
}

/// The three mobile-facing app roles, mapped from the backend's [AppRoles].
enum MobileRole { tenant, agent, manager }

MobileRole? mobileRoleFromBackendRole(String roleName) {
  switch (roleName) {
    case AppRoles.locataire:
      return MobileRole.tenant;
    case AppRoles.agentImmobilier:
      return MobileRole.agent;
    case AppRoles.gestionnaire:
      return MobileRole.manager;
    default:
      return null;
  }
}

class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshTokenCookie = 'refresh_token_cookie';
}
