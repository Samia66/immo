import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../network/api_client.dart';
import '../notifications/local_notification_service.dart';
import '../notifications/notification_service.dart';
import '../storage/secure_storage_service.dart';

/// App-wide singletons, wired once at the root of the provider tree.

final loggerProvider = Provider<Logger>((ref) {
  return Logger(printer: PrettyPrinter(methodCount: 0, colors: false));
});

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    secureStorage: ref.watch(secureStorageProvider),
    logger: ref.watch(loggerProvider),
  );
});

final dioProvider = Provider<Dio>((ref) {
  return ref.watch(apiClientProvider).dio;
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = LocalNotificationService(logger: ref.watch(loggerProvider));
  service.initialize();
  return service;
});
