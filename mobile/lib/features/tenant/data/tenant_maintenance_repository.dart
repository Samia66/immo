import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/models/maintenance_model.dart';
import '../../../core/models/paginated_result.dart';
import '../../../core/network/api_exception.dart';

class TenantMaintenanceRepository {
  TenantMaintenanceRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResult<MaintenanceRequestModel>> myRequests({
    int page = 1,
    int limit = 20,
    MaintenanceStatus? status,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/maintenance/me', queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.name,
      });
      return PaginatedResult<MaintenanceRequestModel>.fromJson(
        response.data!,
        (json) => MaintenanceRequestModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<MaintenanceRequestModel> getDetail(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/maintenance/$id');
      return MaintenanceRequestModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<MaintenanceRequestModel> create({
    required String propertyUnitId,
    required String category,
    required String description,
    MaintenancePriority priority = MaintenancePriority.NORMALE,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/maintenance', data: {
        'propertyUnitId': propertyUnitId,
        'category': category,
        'description': description,
        'priority': priority.name,
      });
      return MaintenanceRequestModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> uploadAttachments({
    required String requestId,
    required List<XFile> files,
    required AttachmentPhase phase,
  }) async {
    if (files.isEmpty) return;
    try {
      final formData = FormData.fromMap({
        'phase': phase.name,
        'files': [
          for (final file in files)
            await MultipartFile.fromFile(file.path, filename: file.name),
        ],
      });
      await _dio.post('/maintenance/$requestId/attachments', data: formData);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
