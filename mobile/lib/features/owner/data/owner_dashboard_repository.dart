import 'package:dio/dio.dart';

import '../../../core/models/owner_dashboard_model.dart';
import '../../../core/network/api_exception.dart';

class OwnerDashboardRepository {
  OwnerDashboardRepository(this._dio);

  final Dio _dio;

  Future<OwnerDashboardModel> get() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/dashboard/owner');
      return OwnerDashboardModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
