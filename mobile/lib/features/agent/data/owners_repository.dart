import 'package:dio/dio.dart';

import '../../../core/models/owner_model.dart';
import '../../../core/models/paginated_result.dart';
import '../../../core/network/api_exception.dart';

class OwnersRepository {
  OwnersRepository(this._dio);

  final Dio _dio;

  Future<OwnerModel> getOwner(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/owners/$id');
      return OwnerModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PaginatedResult<OwnerModel>> list({
    int page = 1,
    int limit = 50,
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
}
