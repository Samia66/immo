import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/tenant_model.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/pagination/paginated_notifier.dart';
import '../../data/tenant_repository.dart';

final managerTenantRepositoryProvider = Provider<ManagerTenantRepository>((ref) {
  return ManagerTenantRepository(ref.watch(dioProvider));
});

class ManagerTenantsNotifier extends PaginatedNotifier<TenantModel> {
  ManagerTenantsNotifier(this._repository) : super(pageSize: 20);

  final ManagerTenantRepository _repository;
  String? search;

  @override
  Future<PaginatedResult<TenantModel>> fetchPage(int page, int limit) {
    return _repository.list(page: page, limit: limit, search: search);
  }

  void setSearch(String? value) {
    search = value;
    loadFirstPage();
  }
}

final managerTenantsListProvider =
    StateNotifierProvider<ManagerTenantsNotifier, AsyncValue<List<TenantModel>>>((ref) {
  return ManagerTenantsNotifier(ref.watch(managerTenantRepositoryProvider));
});

final managerTenantDetailProvider =
    FutureProvider.family<TenantModel, String>((ref, id) async {
  return ref.watch(managerTenantRepositoryProvider).getDetail(id);
});
