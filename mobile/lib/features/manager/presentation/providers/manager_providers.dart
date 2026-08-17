import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/maintenance_model.dart';
import '../../../../core/models/manager_dashboard_model.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/payment_model.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/pagination/paginated_notifier.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/manager_dashboard_repository.dart';
import '../../data/manager_maintenance_repository.dart';
import '../../data/manager_payments_repository.dart';

final managerMaintenanceRepositoryProvider = Provider<ManagerMaintenanceRepository>((ref) {
  return ManagerMaintenanceRepository(ref.watch(dioProvider));
});

final managerPaymentsRepositoryProvider = Provider<ManagerPaymentsRepository>((ref) {
  return ManagerPaymentsRepository(ref.watch(dioProvider));
});

final managerDashboardRepositoryProvider = Provider<ManagerDashboardRepository>((ref) {
  return ManagerDashboardRepository(ref.watch(dioProvider));
});

/// Recent payments for a single unit, keyed by `propertyUnitId` - powers the
/// manager property detail screen's per-unit payments summary.
final unitPaymentsProvider =
    FutureProvider.family<List<PaymentModel>, String>((ref, propertyUnitId) async {
  final result = await ref.watch(managerPaymentsRepositoryProvider).byUnit(propertyUnitId);
  return result.data;
});

// --- Dashboard (GET /dashboard/manager) -----------------------------------

class ManagerDashboardNotifier extends StateNotifier<AsyncValue<ManagerDashboardModel>> {
  ManagerDashboardNotifier(this._repository) : super(const AsyncValue.loading()) {
    refresh();
  }

  final ManagerDashboardRepository _repository;

  Future<void> refresh() async {
    state = AsyncValue<ManagerDashboardModel>.loading().copyWithPrevious(state);
    try {
      final result = await _repository.get();
      if (mounted) state = AsyncValue.data(result);
    } catch (e, st) {
      if (mounted) state = AsyncValue<ManagerDashboardModel>.error(e, st).copyWithPrevious(state);
    }
  }
}

final managerDashboardProvider =
    StateNotifierProvider<ManagerDashboardNotifier, AsyncValue<ManagerDashboardModel>>((ref) {
  return ManagerDashboardNotifier(ref.watch(managerDashboardRepositoryProvider));
});

// --- Payments list (GET /payments, scoped) --------------------------------

class ManagerPaymentsNotifier extends PaginatedNotifier<PaymentModel> {
  ManagerPaymentsNotifier(this._repository) : super(pageSize: 20);

  final ManagerPaymentsRepository _repository;
  PaymentStatus? statusFilter;

  @override
  Future<PaginatedResult<PaymentModel>> fetchPage(int page, int limit) {
    return _repository.list(page: page, limit: limit, status: statusFilter);
  }

  void setStatusFilter(PaymentStatus? status) {
    statusFilter = status;
    loadFirstPage();
  }
}

final managerPaymentsListProvider =
    StateNotifierProvider<ManagerPaymentsNotifier, AsyncValue<List<PaymentModel>>>((ref) {
  return ManagerPaymentsNotifier(ref.watch(managerPaymentsRepositoryProvider));
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
