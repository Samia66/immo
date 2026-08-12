import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

import 'notification_service.dart';

/// [flutter_local_notifications]-backed implementation of [NotificationService].
///
/// Used to surface locally-triggered alerts (e.g. "you have 2 new
/// notifications" after a badge-count refresh). This is intentionally the
/// only notification transport wired up in this pass - see [FcmService] for
/// where a real push transport would plug in later.
class LocalNotificationService implements NotificationService {
  LocalNotificationService({Logger? logger})
      : _logger = logger ?? Logger(printer: SimplePrinter(colors: false));

  final Logger _logger;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'immo_general';
  static const _channelName = 'Notifications générales';

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    try {
      await _plugin.initialize(settings);
      const androidChannel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: 'Rappels de loyer, maintenance, visites, notifications générales',
        importance: Importance.defaultImportance,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
      _initialized = true;
    } catch (e, st) {
      // Local notifications are a non-critical enhancement; never let their
      // setup failure crash app startup (e.g. missing platform channel in a
      // headless/test environment).
      _logger.w('LocalNotificationService.initialize failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        final granted = await androidImpl.requestNotificationsPermission();
        return granted ?? false;
      }
      final iosImpl = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosImpl != null) {
        final granted = await iosImpl.requestPermissions(alert: true, badge: true, sound: true);
        return granted ?? false;
      }
      return false;
    } catch (e) {
      _logger.w('requestPermission failed', error: e);
      return false;
    }
  }

  @override
  Future<void> showLocal({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await initialize();
    try {
      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      );
      const iosDetails = DarwinNotificationDetails();
      const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
      await _plugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      _logger.w('showLocal failed', error: e);
    }
  }
}
