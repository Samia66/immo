import 'package:dio/dio.dart';

import '../../../core/models/paginated_result.dart';
import '../../../core/models/property_model.dart';
import '../../../core/network/api_exception.dart';

class PropertiesRepository {
  PropertiesRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResult<PropertyModel>> list({
    int page = 1,
    int limit = 20,
    PropertyStatus? status,
    PropertyType? type,
    String? city,
    num? minRent,
    num? maxRent,
    String? search,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/properties', queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.name,
        if (type != null) 'type': type.name,
        if (city != null && city.isNotEmpty) 'city': city,
        'minRent': ?minRent,
        'maxRent': ?maxRent,
        if (search != null && search.isNotEmpty) 'search': search,
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
