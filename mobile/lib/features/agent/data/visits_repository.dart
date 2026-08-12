import 'package:dio/dio.dart';

import '../../../core/models/paginated_result.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/network/api_exception.dart';

class VisitsRepository {
  VisitsRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResult<VisitModel>> myVisits({
    int page = 1,
    int limit = 20,
    VisitStatus? status,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/visits/me', queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.name,
      });
      return PaginatedResult<VisitModel>.fromJson(
        response.data!,
        (json) => VisitModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<VisitModel> getDetail(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/visits/$id');
      return VisitModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<VisitModel> create({
    required String propertyId,
    required String clientName,
    String? clientPhone,
    String? clientEmail,
    required DateTime scheduledAt,
    String? notes,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/visits', data: {
        'propertyId': propertyId,
        'clientName': clientName,
        if (clientPhone != null && clientPhone.isNotEmpty) 'clientPhone': clientPhone,
        if (clientEmail != null && clientEmail.isNotEmpty) 'clientEmail': clientEmail,
        'scheduledAt': scheduledAt.toUtc().toIso8601String(),
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });
      return VisitModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<VisitModel> update(
    String id, {
    String? clientName,
    String? clientPhone,
    String? clientEmail,
    DateTime? scheduledAt,
    String? notes,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>('/visits/$id', data: {
        'clientName': ?clientName,
        'clientPhone': ?clientPhone,
        'clientEmail': ?clientEmail,
        if (scheduledAt != null) 'scheduledAt': scheduledAt.toUtc().toIso8601String(),
        'notes': ?notes,
      });
      return VisitModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<VisitModel> complete(
    String id, {
    required VisitStatus status,
    required String outcome,
  }) async {
    assert(status == VisitStatus.REALISEE || status == VisitStatus.ANNULEE);
    try {
      final response = await _dio.patch<Map<String, dynamic>>('/visits/$id/complete', data: {
        'status': status.name,
        'outcome': outcome,
      });
      return VisitModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
