import 'package:dio/dio.dart';

import '../../../core/models/paginated_result.dart';
import '../../../core/models/tenant_model.dart';
import '../../../core/network/api_exception.dart';

/// Manager (GESTIONNAIRE) view of tenants: `GET /tenants` is scoped
/// server-side to the tenants on this manager's leases - no client-side
/// filtering needed.
class ManagerTenantRepository {
  ManagerTenantRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResult<TenantModel>> list({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/tenants', queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      });
      return PaginatedResult<TenantModel>.fromJson(
        response.data!,
        (json) => TenantModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<TenantModel> getDetail(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/tenants/$id');
      return TenantModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// `data` follows the real `CreateTenantDto`: `fullName`, `phone` required;
  /// `email`/`profession`/`employer`/`monthlyIncome` optional.
  Future<TenantModel> create(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/tenants', data: data);
      return TenantModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
