import 'package:dio/dio.dart';

import '../../../core/models/lease_model.dart';
import '../../../core/models/paginated_result.dart';
import '../../../core/models/tenant_invitation_model.dart';
import '../../../core/network/api_exception.dart';
import '../../tenant/data/lease_repository.dart' show LeaseRepository;

/// Manager (GESTIONNAIRE) view of leases/contracts: `GET /leases` is scoped
/// server-side to this manager's own `managerId` - no client-side filtering
/// needed - plus the manager-only workflow actions (create/send/cancel/
/// terminate/renew/invite tenant). `getDetail` reuses the tenant module's
/// [LeaseRepository.getLease] (identical `GET /leases/:id` call) rather than
/// duplicating it - only the tenant-only actions (acknowledge/accept/refuse)
/// stay out of this class, per the task brief.
class ManagerLeaseRepository {
  ManagerLeaseRepository(this._dio) : _shared = LeaseRepository(_dio);

  final Dio _dio;
  final LeaseRepository _shared;

  Future<PaginatedResult<LeaseModel>> list({
    int page = 1,
    int limit = 20,
    LeaseStatus? status,
    String? propertyUnitId,
    String? tenantId,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/leases', queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.name,
        'propertyUnitId': ?propertyUnitId,
        'tenantId': ?tenantId,
      });
      return PaginatedResult<LeaseModel>.fromJson(
        response.data!,
        (json) => LeaseModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LeaseModel> getDetail(String id) => _shared.getLease(id);

  /// `data` follows the real `CreateLeaseDto`: `propertyUnitId`, `tenantId`,
  /// `startDate`, `rentAmount`, `depositAmount`, `paymentFrequency` required;
  /// `endDate`/`indexationRate` optional.
  Future<LeaseModel> create(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/leases', data: data);
      return LeaseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// BROUILLON -> ENVOYE.
  Future<LeaseModel> send(String id) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/leases/$id/send');
      return LeaseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LeaseModel> cancel(String id) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/leases/$id/cancel');
      return LeaseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LeaseModel> terminate(String id, {required DateTime terminationDate, String? reason}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/leases/$id/terminate', data: {
        'terminationDate': terminationDate.toIso8601String().split('T').first,
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      });
      return LeaseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LeaseModel> renew(String id, {required DateTime newEndDate, String? amendmentDescription}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/leases/$id/renew', data: {
        'newEndDate': newEndDate.toIso8601String().split('T').first,
        if (amendmentDescription != null && amendmentDescription.isNotEmpty)
          'amendmentDescription': amendmentDescription,
      });
      return LeaseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Generates (or regenerates) the lease's `TenantInvitation`.
  Future<TenantInvitationModel> invite(String id) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/leases/$id/invite');
      return TenantInvitationModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
