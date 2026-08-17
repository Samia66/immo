import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/owner_dashboard_model.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/property_model.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/pagination/paginated_notifier.dart';
import '../../data/owner_dashboard_repository.dart';
import '../../data/owner_properties_repository.dart';

// --- Repositories -----------------------------------------------------

final ownerPropertiesRepositoryProvider = Provider<OwnerPropertiesRepository>((ref) {
  return OwnerPropertiesRepository(ref.watch(dioProvider));
});

final ownerDashboardRepositoryProvider = Provider<OwnerDashboardRepository>((ref) {
  return OwnerDashboardRepository(ref.watch(dioProvider));
});

// --- Dashboard ----------------------------------------------------------

class OwnerDashboardNotifier extends StateNotifier<AsyncValue<OwnerDashboardModel>> {
  OwnerDashboardNotifier(this._repository) : super(const AsyncValue.loading()) {
    refresh();
  }

  final OwnerDashboardRepository _repository;

  Future<void> refresh() async {
    state = AsyncValue<OwnerDashboardModel>.loading().copyWithPrevious(state);
    try {
      final result = await _repository.get();
      if (mounted) state = AsyncValue.data(result);
    } catch (e, st) {
      if (mounted) state = AsyncValue<OwnerDashboardModel>.error(e, st).copyWithPrevious(state);
    }
  }
}

final ownerDashboardProvider =
    StateNotifierProvider<OwnerDashboardNotifier, AsyncValue<OwnerDashboardModel>>((ref) {
  return OwnerDashboardNotifier(ref.watch(ownerDashboardRepositoryProvider));
});

// --- Properties -----------------------------------------------------------

class OwnerPropertiesNotifier extends PaginatedNotifier<PropertyModel> {
  OwnerPropertiesNotifier(this._repository) : super(pageSize: 20);

  final OwnerPropertiesRepository _repository;
  PropertyStatus? unitStatusFilter;

  @override
  Future<PaginatedResult<PropertyModel>> fetchPage(int page, int limit) {
    return _repository.list(page: page, limit: limit, unitStatus: unitStatusFilter);
  }

  void setUnitStatusFilter(PropertyStatus? status) {
    unitStatusFilter = status;
    loadFirstPage();
  }
}

final ownerPropertiesListProvider =
    StateNotifierProvider<OwnerPropertiesNotifier, AsyncValue<List<PropertyModel>>>((ref) {
  return OwnerPropertiesNotifier(ref.watch(ownerPropertiesRepositoryProvider));
});

final ownerPropertyDetailProvider =
    FutureProvider.family<PropertyModel, String>((ref, id) async {
  return ref.watch(ownerPropertiesRepositoryProvider).getDetail(id);
});
