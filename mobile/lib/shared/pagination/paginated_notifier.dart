import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/paginated_result.dart';

/// Base class for every paginated list screen's state notifier.
///
/// Subclasses implement [fetchPage]; this base handles the page/hasMore
/// bookkeeping, pull-to-refresh (via [refresh], which uses
/// `copyWithPrevious` so the current list stays visible - with a refresh
/// spinner overlay - instead of flashing to a blank loading state), and
/// infinite-scroll pagination (via [loadMore]).
abstract class PaginatedNotifier<T> extends StateNotifier<AsyncValue<List<T>>> {
  PaginatedNotifier({this.pageSize = 20}) : super(const AsyncValue.loading()) {
    loadFirstPage();
  }

  final int pageSize;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  List<T> _items = const [];

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<PaginatedResult<T>> fetchPage(int page, int limit);

  Future<void> loadFirstPage() async {
    state = AsyncValue<List<T>>.loading().copyWithPrevious(state);
    try {
      final result = await fetchPage(1, pageSize);
      _page = 1;
      _items = result.data;
      _hasMore = result.meta.page < result.meta.totalPages;
      if (mounted) state = AsyncValue.data(_items);
    } catch (e, st) {
      if (mounted) state = AsyncValue<List<T>>.error(e, st).copyWithPrevious(state);
    }
  }

  Future<void> refresh() => loadFirstPage();

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    try {
      final nextPage = _page + 1;
      final result = await fetchPage(nextPage, pageSize);
      _page = nextPage;
      _items = [..._items, ...result.data];
      _hasMore = result.meta.page < result.meta.totalPages;
      if (mounted) state = AsyncValue.data(_items);
    } catch (_) {
      // Keep existing items on a load-more failure; the user can retry by
      // scrolling again or pulling to refresh.
    } finally {
      _isLoadingMore = false;
    }
  }
}
