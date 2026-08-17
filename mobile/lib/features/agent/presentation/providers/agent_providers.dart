import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/owner_model.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/property_model.dart';
import '../../../../core/models/visit_model.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/pagination/paginated_notifier.dart';
import '../../data/owners_repository.dart';
import '../../data/properties_repository.dart';
import '../../data/visits_repository.dart';

// --- Repositories -------------------------------------------------------

final propertiesRepositoryProvider = Provider<PropertiesRepository>((ref) {
  return PropertiesRepository(ref.watch(dioProvider));
});

final ownersRepositoryProvider = Provider<OwnersRepository>((ref) {
  return OwnersRepository(ref.watch(dioProvider));
});

final visitsRepositoryProvider = Provider<VisitsRepository>((ref) {
  return VisitsRepository(ref.watch(dioProvider));
});

// --- Properties -----------------------------------------------------------

class PropertiesFilter {
  const PropertiesFilter({
    this.unitStatus = PropertyStatus.DISPONIBLE,
    this.type,
    this.city,
    this.minRent,
    this.maxRent,
    this.search,
  });

  /// Filters properties having at least one unit in this status - see
  /// `QueryPropertyDto.unitStatus` (Property itself has no status).
  final PropertyStatus? unitStatus;
  final PropertyType? type;
  final String? city;
  final num? minRent;
  final num? maxRent;
  final String? search;

  PropertiesFilter copyWith({
    PropertyStatus? unitStatus,
    bool clearStatus = false,
    PropertyType? type,
    bool clearType = false,
    String? city,
    num? minRent,
    num? maxRent,
    String? search,
  }) {
    return PropertiesFilter(
      unitStatus: clearStatus ? null : (unitStatus ?? this.unitStatus),
      type: clearType ? null : (type ?? this.type),
      city: city ?? this.city,
      minRent: minRent ?? this.minRent,
      maxRent: maxRent ?? this.maxRent,
      search: search ?? this.search,
    );
  }
}

class PropertiesListNotifier extends PaginatedNotifier<PropertyModel> {
  PropertiesListNotifier(this._repository) : super(pageSize: 20);

  final PropertiesRepository _repository;
  PropertiesFilter filter = const PropertiesFilter();

  @override
  Future<PaginatedResult<PropertyModel>> fetchPage(int page, int limit) {
    return _repository.list(
      page: page,
      limit: limit,
      unitStatus: filter.unitStatus,
      type: filter.type,
      city: filter.city,
      minRent: filter.minRent,
      maxRent: filter.maxRent,
      search: filter.search,
    );
  }

  void applyFilter(PropertiesFilter next) {
    filter = next;
    loadFirstPage();
  }
}

final propertiesListProvider =
    StateNotifierProvider<PropertiesListNotifier, AsyncValue<List<PropertyModel>>>((ref) {
  return PropertiesListNotifier(ref.watch(propertiesRepositoryProvider));
});

final propertyDetailProvider =
    FutureProvider.family<PropertyModel, String>((ref, id) async {
  return ref.watch(propertiesRepositoryProvider).getDetail(id);
});

final ownerDetailProvider =
    FutureProvider.family<OwnerModel, String>((ref, ownerId) async {
  return ref.watch(ownersRepositoryProvider).getOwner(ownerId);
});

// --- Visits ---------------------------------------------------------------

class VisitsListNotifier extends PaginatedNotifier<VisitModel> {
  VisitsListNotifier(this._repository) : super(pageSize: 20);

  final VisitsRepository _repository;
  VisitStatus? statusFilter;

  @override
  Future<PaginatedResult<VisitModel>> fetchPage(int page, int limit) {
    return _repository.myVisits(page: page, limit: limit, status: statusFilter);
  }

  void setStatusFilter(VisitStatus? status) {
    statusFilter = status;
    loadFirstPage();
  }
}

final visitsListProvider =
    StateNotifierProvider<VisitsListNotifier, AsyncValue<List<VisitModel>>>((ref) {
  return VisitsListNotifier(ref.watch(visitsRepositoryProvider));
});

final visitDetailProvider =
    FutureProvider.family<VisitModel, String>((ref, id) async {
  return ref.watch(visitsRepositoryProvider).getDetail(id);
});
