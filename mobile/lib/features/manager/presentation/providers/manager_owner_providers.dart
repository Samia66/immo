import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/owner_invitation_model.dart';
import '../../../../core/models/owner_model.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/pagination/paginated_notifier.dart';
import '../../data/owner_repository.dart';

final managerOwnerRepositoryProvider = Provider<ManagerOwnerRepository>((ref) {
  return ManagerOwnerRepository(ref.watch(dioProvider));
});

// --- "Mes propriétaires" list --------------------------------------------

class ManagerOwnersNotifier extends PaginatedNotifier<OwnerModel> {
  ManagerOwnersNotifier(this._repository) : super(pageSize: 20);

  final ManagerOwnerRepository _repository;
  String? search;

  @override
  Future<PaginatedResult<OwnerModel>> fetchPage(int page, int limit) {
    return _repository.list(page: page, limit: limit, search: search);
  }

  void setSearch(String? value) {
    search = value;
    loadFirstPage();
  }
}

final managerOwnersListProvider =
    StateNotifierProvider<ManagerOwnersNotifier, AsyncValue<List<OwnerModel>>>((ref) {
  return ManagerOwnersNotifier(ref.watch(managerOwnerRepositoryProvider));
});

final managerOwnerDetailProvider =
    FutureProvider.family<OwnerModel, String>((ref, id) async {
  return ref.watch(managerOwnerRepositoryProvider).getOwner(id);
});

/// Whether this manager already manages at least one owner - drives the
/// "Invitez d'abord un propriétaire" gate on property creation (spec: `POST
/// /properties` now requires a real `ownerId` this manager actually manages).
final managerHasOwnersProvider = FutureProvider<bool>((ref) async {
  final result = await ref.watch(managerOwnerRepositoryProvider).list(page: 1, limit: 1);
  return result.meta.total > 0;
});

// --- Sent owner invitations ------------------------------------------------

class ManagerOwnerInvitationsNotifier extends PaginatedNotifier<OwnerInvitationModel> {
  ManagerOwnerInvitationsNotifier(this._repository) : super(pageSize: 20);

  final ManagerOwnerRepository _repository;

  @override
  Future<PaginatedResult<OwnerInvitationModel>> fetchPage(int page, int limit) {
    return _repository.listInvitations(page: page, limit: limit);
  }
}

final managerOwnerInvitationsProvider = StateNotifierProvider<ManagerOwnerInvitationsNotifier,
    AsyncValue<List<OwnerInvitationModel>>>((ref) {
  return ManagerOwnerInvitationsNotifier(ref.watch(managerOwnerRepositoryProvider));
});
