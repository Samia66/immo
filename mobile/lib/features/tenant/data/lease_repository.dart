import 'package:dio/dio.dart';

import '../../../core/models/lease_model.dart';
import '../../../core/network/api_exception.dart';

class LeaseRepository {
  LeaseRepository(this._dio);

  final Dio _dio;

  Future<LeaseModel> getLease(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/leases/$id');
      return LeaseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
