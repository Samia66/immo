/// Abstraction over "a notification appeared, show it to the user locally".
///
/// This app does NOT wire real push notifications (no Firebase project
/// credentials exist in this sandbox) - see [FcmService] for the clearly
/// marked plug-in point. What IS implemented is a local-notifications
/// backend ([LocalNotificationService]) so the abstraction and its call
/// sites are real and swappable later without touching calling code.
abstract class NotificationService {
  Future<void> initialize();

  /// Show a local notification immediately (e.g. after detecting new unread
  /// notifications on a poll/refresh).
  Future<void> showLocal({
    required String title,
    required String body,
    String? payload,
  });

  /// Request the OS-level notification permission (Android 13+, iOS).
  Future<bool> requestPermission();
}
