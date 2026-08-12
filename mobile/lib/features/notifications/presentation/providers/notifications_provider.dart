import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/notification_model.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/notifications_repository.dart';
import '../../../../shared/pagination/paginated_notifier.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(ref.watch(dioProvider));
});

class NotificationsListNotifier extends PaginatedNotifier<NotificationModel> {
  NotificationsListNotifier(this._repository) : super(pageSize: 20);

  final NotificationsRepository _repository;

  @override
  Future<PaginatedResult<NotificationModel>> fetchPage(int page, int limit) {
    return _repository.list(page: page, limit: limit);
  }

  Future<void> markRead(String id) async {
    await _repository.markRead(id);
    await refresh();
  }

  Future<void> markAllRead() async {
    await _repository.markAllRead();
    await refresh();
  }
}

final notificationsListProvider =
    StateNotifierProvider<NotificationsListNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  return NotificationsListNotifier(ref.watch(notificationsRepositoryProvider));
});

/// Unread-count badge: refreshed manually (pull-to-refresh / app resume) and
/// via a lightweight periodic poll while the app is in foreground - no real
/// push transport is wired up (see core/notifications/fcm_service.dart).
class UnreadCountNotifier extends StateNotifier<AsyncValue<int>> {
  UnreadCountNotifier(this._repository) : super(const AsyncValue.data(0)) {
    refresh();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) => refresh());
  }

  final NotificationsRepository _repository;
  Timer? _timer;

  Future<void> refresh() async {
    try {
      final count = await _repository.unreadCount();
      if (mounted) state = AsyncValue.data(count);
    } catch (e, st) {
      if (mounted) state = AsyncValue<int>.error(e, st).copyWithPrevious(state);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final unreadCountProvider =
    StateNotifierProvider<UnreadCountNotifier, AsyncValue<int>>((ref) {
  return UnreadCountNotifier(ref.watch(notificationsRepositoryProvider));
});
