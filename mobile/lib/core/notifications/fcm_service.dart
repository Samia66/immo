/// STUB - Firebase Cloud Messaging is NOT wired up in this build.
///
/// No Firebase project / `google-services.json` / `GoogleService-Info.plist`
/// credentials exist in this sandbox, so real push notifications cannot be
/// configured or tested end-to-end here. This class exists purely to mark
/// the exact, one-file integration point for later:
///
/// To wire real push notifications:
///   1. Add `firebase_core` and `firebase_messaging` to pubspec.yaml.
///   2. Run `flutterfire configure` (or manually drop in the platform
///      config files) to generate `firebase_options.dart`.
///   3. In `initialize()` below: call `Firebase.initializeApp(...)`,
///      request permission via `FirebaseMessaging.instance.requestPermission()`,
///      obtain the device token via `FirebaseMessaging.instance.getToken()`
///      and POST it to a (currently nonexistent) backend endpoint such as
///      `POST /notifications/device-tokens`.
///   4. Wire `FirebaseMessaging.onMessage` (foreground) to
///      `NotificationService.showLocal(...)` and
///      `FirebaseMessaging.onBackgroundMessage` to a top-level handler.
///   5. Nothing else in the app needs to change - callers only ever depend
///      on the [NotificationService] abstraction, never on this class
///      directly.
class FcmService {
  FcmService();

  bool get isConfigured => false;

  Future<void> initialize() async {
    // Intentionally a no-op stub - see class doc.
  }

  Future<String?> getDeviceToken() async => null;
}
