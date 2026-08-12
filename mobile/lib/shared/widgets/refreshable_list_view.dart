import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'empty_state.dart';
import 'error_view.dart';
import 'loading_skeleton.dart';

/// Wraps a paginated/plain list `AsyncValue<List<T>>` with:
/// - pull-to-refresh (RefreshIndicator),
/// - a skeleton loading state,
/// - an empty state,
/// - an error state with retry,
/// - and (when the AsyncNotifier uses `copyWithPrevious`) shows stale data
///   with a refresh spinner instead of a blank screen while refreshing -
///   i.e. the "offline: show cached/last-known data" behavior from the spec.
class RefreshableListView<T> extends ConsumerWidget {
  const RefreshableListView({
    super.key,
    required this.value,
    required this.onRefresh,
    required this.itemBuilder,
    required this.emptyIcon,
    required this.emptyTitle,
    this.emptyMessage,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 24),
    this.header,
  });

  final AsyncValue<List<T>> value;
  final Future<void> Function() onRefresh;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final IconData emptyIcon;
  final String emptyTitle;
  final String? emptyMessage;
  final EdgeInsetsGeometry padding;
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return value.when(
      data: (items) {
        if (items.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              padding: padding,
              children: [
                ?header,
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.55,
                  child: EmptyStateView(
                    icon: emptyIcon,
                    title: emptyTitle,
                    message: emptyMessage,
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            padding: padding,
            itemCount: items.length + (header != null ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (header != null) {
                if (index == 0) return header!;
                return itemBuilder(context, items[index - 1]);
              }
              return itemBuilder(context, items[index]);
            },
          ),
        );
      },
      error: (error, stackTrace) => ErrorView(
        message: error.toString(),
        onRetry: onRefresh,
      ),
      loading: () => const SkeletonList(),
    );
  }
}
