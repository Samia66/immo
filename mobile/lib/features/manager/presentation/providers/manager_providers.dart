import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/maintenance_model.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/pagination/paginated_notifier.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/manager_maintenance_repository.dart';

final managerMaintenanceRepositoryProvider = Provider<ManagerMaintenanceRepository>((ref) {
  return ManagerMaintenanceRepository(ref.watch(dioProvider));
});

class AssignedMaintenanceNotifier extends PaginatedNotifier<MaintenanceRequestModel> {
  AssignedMaintenanceNotifier(this._repository, this._userId) : super(pageSize: 20);

  final ManagerMaintenanceRepository _repository;
  final String? _userId;
  MaintenanceStatus? statusFilter;

  @override
  Future<PaginatedResult<MaintenanceRequestModel>> fetchPage(int page, int limit) {
    final userId = _userId;
    if (userId == null) {
      return Future.value(const PaginatedResult(
        data: [],
        meta: PaginationMeta(total: 0, page: 1, limit: 20, totalPages: 0),
      ));
    }
    return _repository.assignedTo(userId: userId, page: page, limit: limit, status: statusFilter);
  }

  void setStatusFilter(MaintenanceStatus? status) {
    statusFilter = status;
    loadFirstPage();
  }
}

final assignedMaintenanceProvider = StateNotifierProvider<AssignedMaintenanceNotifier,
    AsyncValue<List<MaintenanceRequestModel>>>((ref) {
  final userId = ref.watch(authNotifierProvider).user?.id;
  return AssignedMaintenanceNotifier(ref.watch(managerMaintenanceRepositoryProvider), userId);
});

final managerMaintenanceDetailProvider =
    FutureProvider.family<MaintenanceRequestModel, String>((ref, id) async {
  return ref.watch(managerMaintenanceRepositoryProvider).getDetail(id);
});
