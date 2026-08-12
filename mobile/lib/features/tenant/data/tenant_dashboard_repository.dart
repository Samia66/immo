import 'package:dio/dio.dart';

import '../../../core/models/tenant_dashboard_model.dart';
import '../../../core/network/api_exception.dart';

class TenantDashboardRepository {
  TenantDashboardRepository(this._dio);

  final Dio _dio;

  Future<TenantDashboardModel> getDashboard() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/dashboard/tenant');
      return TenantDashboardModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
