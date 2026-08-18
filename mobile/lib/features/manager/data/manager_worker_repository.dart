import 'package:dio/dio.dart';

import '../../../core/models/paginated_result.dart';
import '../../../core/models/worker_model.dart';
import '../../../core/network/api_exception.dart';

/// Manager (GESTIONNAIRE) view of the worker/contractor address book:
/// `GET /workers` is scoped server-side to this manager's own managed
/// properties (plus "general" workers with no property), and this class
/// owns the create/update/delete actions the manager UI needs.
class ManagerWorkerRepository {
  ManagerWorkerRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResult<WorkerModel>> list({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/workers', queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      });
      return PaginatedResult<WorkerModel>.fromJson(
        response.data!,
        (json) => WorkerModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<WorkerModel> getDetail(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/workers/$id');
      return WorkerModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// `data` follows the real `CreateWorkerDto`: `fullName`, `trade`, `phone`
  /// required; `email`/`notes`/`propertyId`/`isActive` optional.
  Future<WorkerModel> create(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/workers', data: data);
      return WorkerModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<WorkerModel> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>('/workers/$id', data: data);
      return WorkerModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> remove(String id) async {
    try {
      await _dio.delete('/workers/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
