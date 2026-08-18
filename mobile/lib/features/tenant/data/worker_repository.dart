import 'package:dio/dio.dart';

import '../../../core/models/worker_model.dart';
import '../../../core/network/api_exception.dart';

/// Tenant (LOCATAIRE) read-only view of the worker/contractor address book:
/// `GET /workers/me` returns the workers rattached to the tenant's own
/// property, plus "general" ones with no property - so a tenant has someone
/// to call in case of a problem.
class WorkerRepository {
  WorkerRepository(this._dio);

  final Dio _dio;

  Future<List<WorkerModel>> myWorkers() async {
    try {
      final response = await _dio.get<List<dynamic>>('/workers/me');
      return (response.data ?? [])
          .map((json) => WorkerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
