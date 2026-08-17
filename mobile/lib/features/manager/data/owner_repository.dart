import 'package:dio/dio.dart';

import '../../../core/models/owner_invitation_model.dart';
import '../../../core/models/owner_model.dart';
import '../../../core/models/paginated_result.dart';
import '../../../core/network/api_exception.dart';

/// Manager (GESTIONNAIRE) view of owners: `GET /owners` is scoped
/// server-side to just the owners this manager manages (via `ManagerOwner`
/// ACTIVE rows) - no client-side filtering needed - plus the owner-invitation
/// flow (`/owners/invitations/...`, bearer-authenticated side only; the
/// public preview/accept pair lives in [OwnerInvitationRepository] under the
/// auth feature since it's used pre-login).
class ManagerOwnerRepository {
  ManagerOwnerRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResult<OwnerModel>> list({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/owners', queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      });
      return PaginatedResult<OwnerModel>.fromJson(
        response.data!,
        (json) => OwnerModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// `GET /owners/:id` - detail response includes `propertiesCount`,
  /// `totalRevenue` and a `properties` summary list the list endpoint omits.
  Future<OwnerModel> getOwner(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/owners/$id');
      return OwnerModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<OwnerInvitationModel> inviteOwner({
    required String firstName,
    required String lastName,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/owners/invitations', data: {
        'firstName': firstName,
        'lastName': lastName,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      });
      return OwnerInvitationModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PaginatedResult<OwnerInvitationModel>> listInvitations({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>('/owners/invitations', queryParameters: {
        'page': page,
        'limit': limit,
      });
      return PaginatedResult<OwnerInvitationModel>.fromJson(
        response.data!,
        (json) => OwnerInvitationModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<OwnerInvitationModel> cancelInvitation(String id) async {
    try {
      final response =
          await _dio.post<Map<String, dynamic>>('/owners/invitations/$id/cancel');
      return OwnerInvitationModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
