import 'package:dio/dio.dart';

import '../../../core/models/paginated_result.dart';
import '../../../core/models/property_model.dart';
import '../../../core/network/api_exception.dart';

class PropertiesRepository {
  PropertiesRepository(this._dio);

  final Dio _dio;

  /// Filtering follows the real `QueryPropertyDto`: `unitStatus`/`minRent`/
  /// `maxRent` filter properties that have AT LEAST ONE unit matching (rent
  /// and status are unit-level now, not on Property itself).
  Future<PaginatedResult<PropertyModel>> list({
    int page = 1,
    int limit = 20,
    PropertyStatus? unitStatus,
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
        if (unitStatus != null) 'unitStatus': unitStatus.name,
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

  /// Creates a property (a building/listing container - no rent/status of
  /// its own). `data` must follow the backend's `CreatePropertyDto` shape
  /// (title, type, addressLine, city, ownerId required; the rest optional).
  /// Its first leasable [PropertyUnitModel] must be created separately via
  /// [createUnit].
  Future<PropertyModel> create(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/properties', data: data);
      return PropertyModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Partially updates a property. `data` follows `UpdatePropertyDto`
  /// (`CreatePropertyDto` fields, all optional).
  Future<PropertyModel> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>('/properties/$id', data: data);
      return PropertyModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Creates a leasable unit on an existing property. `data` follows
  /// `CreatePropertyUnitDto` (reference, type, monthlyRent required; label,
  /// floor, rooms, surfaceM2, monthlyCharges, description optional).
  Future<PropertyUnitModel> createUnit(String propertyId, Map<String, dynamic> data) async {
    try {
      final response =
          await _dio.post<Map<String, dynamic>>('/properties/$propertyId/units', data: data);
      return PropertyUnitModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
