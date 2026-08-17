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

  /// ENVOYE -> CONSULTE, tenant-only, no body. Called automatically the
  /// first time the tenant opens the lease detail screen.
  Future<LeaseModel> acknowledge(String id) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/leases/$id/acknowledge');
      return LeaseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ENVOYE/CONSULTE -> ACTIF directly, tenant-only, no body. Sets the unit
  /// OCCUPE and generates the first Payment server-side.
  Future<LeaseModel> accept(String id) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/leases/$id/accept');
      return LeaseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ENVOYE/CONSULTE -> REFUSE, tenant-only, optional reason.
  Future<LeaseModel> refuse(String id, {String? reason}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/leases/$id/refuse',
        data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
      );
      return LeaseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
