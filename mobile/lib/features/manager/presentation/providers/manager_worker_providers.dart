import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/worker_model.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/pagination/paginated_notifier.dart';
import '../../data/manager_worker_repository.dart';

final managerWorkerRepositoryProvider = Provider<ManagerWorkerRepository>((ref) {
  return ManagerWorkerRepository(ref.watch(dioProvider));
});

class ManagerWorkersNotifier extends PaginatedNotifier<WorkerModel> {
  ManagerWorkersNotifier(this._repository) : super(pageSize: 20);

  final ManagerWorkerRepository _repository;
  String? search;

  @override
  Future<PaginatedResult<WorkerModel>> fetchPage(int page, int limit) {
    return _repository.list(page: page, limit: limit, search: search);
  }

  void setSearch(String? value) {
    search = value;
    loadFirstPage();
  }
}

final managerWorkersListProvider =
    StateNotifierProvider<ManagerWorkersNotifier, AsyncValue<List<WorkerModel>>>((ref) {
  return ManagerWorkersNotifier(ref.watch(managerWorkerRepositoryProvider));
});

final managerWorkerDetailProvider =
    FutureProvider.family<WorkerModel, String>((ref, id) async {
  return ref.watch(managerWorkerRepositoryProvider).getDetail(id);
});
