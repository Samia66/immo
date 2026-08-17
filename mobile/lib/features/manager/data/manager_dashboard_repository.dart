import 'package:dio/dio.dart';

import '../../../core/models/manager_dashboard_model.dart';
import '../../../core/network/api_exception.dart';

class ManagerDashboardRepository {
  ManagerDashboardRepository(this._dio);

  final Dio _dio;

  Future<ManagerDashboardModel> get() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/dashboard/manager');
      return ManagerDashboardModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
