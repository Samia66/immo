import 'package:dio/dio.dart';

import '../../../core/models/paginated_result.dart';
import '../../../core/models/property_model.dart';
import '../../../core/network/api_exception.dart';

/// PROPRIETAIRE portal: `GET /properties/me`, the owner's own properties
/// (each with its `units`, each unit's `currentTenant`). Filtering follows
/// the backend's real `QueryPropertyDto` - it filters properties that have
/// at least one unit in the given status (`unitStatus`), not a `status` on
/// the property itself (Property no longer has a status).
class OwnerPropertiesRepository {
  OwnerPropertiesRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResult<PropertyModel>> list({
    int page = 1,
    int limit = 20,
    PropertyStatus? unitStatus,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/properties/me', queryParameters: {
        'page': page,
        'limit': limit,
        if (unitStatus != null) 'unitStatus': unitStatus.name,
      });
      return PaginatedResult<PropertyModel>.fromJson(
        response.data!,
        (json) => PropertyModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PropertyModel> getDetail(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/properties/$id');
      return PropertyModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
