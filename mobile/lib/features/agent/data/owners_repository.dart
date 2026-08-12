import 'package:dio/dio.dart';

import '../../../core/models/owner_model.dart';
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
}
