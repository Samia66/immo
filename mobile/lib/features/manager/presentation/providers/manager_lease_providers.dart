import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/lease_model.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/pagination/paginated_notifier.dart';
import '../../data/manager_lease_repository.dart';

final managerLeaseRepositoryProvider = Provider<ManagerLeaseRepository>((ref) {
  return ManagerLeaseRepository(ref.watch(dioProvider));
});

class ManagerLeasesNotifier extends PaginatedNotifier<LeaseModel> {
  ManagerLeasesNotifier(this._repository) : super(pageSize: 20);

  final ManagerLeaseRepository _repository;
  LeaseStatus? statusFilter;

  @override
  Future<PaginatedResult<LeaseModel>> fetchPage(int page, int limit) {
    return _repository.list(page: page, limit: limit, status: statusFilter);
  }

  void setStatusFilter(LeaseStatus? status) {
    statusFilter = status;
    loadFirstPage();
  }
}

final managerLeasesListProvider =
    StateNotifierProvider<ManagerLeasesNotifier, AsyncValue<List<LeaseModel>>>((ref) {
  return ManagerLeasesNotifier(ref.watch(managerLeaseRepositoryProvider));
});

final managerLeaseDetailProvider =
    FutureProvider.family<LeaseModel, String>((ref, id) async {
  return ref.watch(managerLeaseRepositoryProvider).getDetail(id);
});
