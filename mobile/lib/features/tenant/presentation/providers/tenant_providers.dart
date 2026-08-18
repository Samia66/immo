import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/lease_model.dart';
import '../../../../core/models/maintenance_model.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/payment_model.dart';
import '../../../../core/models/tenant_dashboard_model.dart';
import '../../../../core/models/worker_model.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/pagination/paginated_notifier.dart';
import '../../data/lease_repository.dart';
import '../../data/payment_repository.dart';
import '../../data/tenant_dashboard_repository.dart';
import '../../data/tenant_maintenance_repository.dart';
import '../../data/worker_repository.dart';

// --- Repositories -----------------------------------------------------

final tenantDashboardRepositoryProvider = Provider<TenantDashboardRepository>((ref) {
  return TenantDashboardRepository(ref.watch(dioProvider));
});

final leaseRepositoryProvider = Provider<LeaseRepository>((ref) {
  return LeaseRepository(ref.watch(dioProvider));
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ref.watch(dioProvider));
});

final tenantMaintenanceRepositoryProvider = Provider<TenantMaintenanceRepository>((ref) {
  return TenantMaintenanceRepository(ref.watch(dioProvider));
});

final workerRepositoryProvider = Provider<WorkerRepository>((ref) {
  return WorkerRepository(ref.watch(dioProvider));
});

// --- Dashboard ----------------------------------------------------------

class TenantDashboardNotifier extends StateNotifier<AsyncValue<TenantDashboardModel>> {
  TenantDashboardNotifier(this._repository) : super(const AsyncValue.loading()) {
    refresh();
  }

  final TenantDashboardRepository _repository;

  Future<void> refresh() async {
    state = AsyncValue<TenantDashboardModel>.loading().copyWithPrevious(state);
    try {
      final result = await _repository.getDashboard();
      if (mounted) state = AsyncValue.data(result);
    } catch (e, st) {
      if (mounted) state = AsyncValue<TenantDashboardModel>.error(e, st).copyWithPrevious(state);
    }
  }
}

final tenantDashboardProvider =
    StateNotifierProvider<TenantDashboardNotifier, AsyncValue<TenantDashboardModel>>((ref) {
  return TenantDashboardNotifier(ref.watch(tenantDashboardRepositoryProvider));
});

// --- Lease ----------------------------------------------------------------

final leaseDetailProvider =
    FutureProvider.family<LeaseModel, String>((ref, leaseId) async {
  return ref.watch(leaseRepositoryProvider).getLease(leaseId);
});

// --- Payments ---------------------------------------------------------

class TenantPaymentsNotifier extends PaginatedNotifier<PaymentModel> {
  TenantPaymentsNotifier(this._repository) : super(pageSize: 20);

  final PaymentRepository _repository;
  PaymentStatus? statusFilter;

  @override
  Future<PaginatedResult<PaymentModel>> fetchPage(int page, int limit) {
    return _repository.myPayments(page: page, limit: limit, status: statusFilter);
  }

  void setStatusFilter(PaymentStatus? status) {
    statusFilter = status;
    loadFirstPage();
  }
}

final tenantPaymentsProvider =
    StateNotifierProvider<TenantPaymentsNotifier, AsyncValue<List<PaymentModel>>>((ref) {
  return TenantPaymentsNotifier(ref.watch(paymentRepositoryProvider));
});

final paymentDetailProvider =
    FutureProvider.family<PaymentModel, String>((ref, id) async {
  return ref.watch(paymentRepositoryProvider).getPayment(id);
});

// --- Maintenance ------------------------------------------------------

class TenantMaintenanceNotifier extends PaginatedNotifier<MaintenanceRequestModel> {
  TenantMaintenanceNotifier(this._repository) : super(pageSize: 20);

  final TenantMaintenanceRepository _repository;
  MaintenanceStatus? statusFilter;

  @override
  Future<PaginatedResult<MaintenanceRequestModel>> fetchPage(int page, int limit) {
    return _repository.myRequests(page: page, limit: limit, status: statusFilter);
  }

  void setStatusFilter(MaintenanceStatus? status) {
    statusFilter = status;
    loadFirstPage();
  }
}

final tenantMaintenanceProvider = StateNotifierProvider<TenantMaintenanceNotifier,
    AsyncValue<List<MaintenanceRequestModel>>>((ref) {
  return TenantMaintenanceNotifier(ref.watch(tenantMaintenanceRepositoryProvider));
});

final maintenanceDetailProvider =
    FutureProvider.family<MaintenanceRequestModel, String>((ref, id) async {
  return ref.watch(tenantMaintenanceRepositoryProvider).getDetail(id);
});

// --- Workers ------------------------------------------------------------

final myWorkersProvider = FutureProvider<List<WorkerModel>>((ref) async {
  return ref.watch(workerRepositoryProvider).myWorkers();
});
