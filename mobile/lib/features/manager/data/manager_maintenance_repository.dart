import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/models/maintenance_model.dart';
import '../../../core/models/paginated_result.dart';
import '../../../core/network/api_exception.dart';

/// Manager view of maintenance requests: `GET /maintenance` either unfiltered
/// (the general queue, scoped server-side to this manager's own managed
/// properties) or filtered by `assignedToId` (the current user's "field"
/// work), plus the validate/assign/status-transition and attachment-upload
/// actions the manager workflow needs.
class ManagerMaintenanceRepository {
  ManagerMaintenanceRepository(this._dio);

  final Dio _dio;

  /// The general queue: every request on a property this manager manages,
  /// regardless of who (if anyone) it's assigned to. This is what surfaces a
  /// brand-new NOUVELLE request a tenant just created - `assignedTo()` below
  /// never will, since a new request has no assignee yet.
  Future<PaginatedResult<MaintenanceRequestModel>> list({
    int page = 1,
    int limit = 20,
    MaintenanceStatus? status,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/maintenance', queryParameters: {
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

  /// NOUVELLE -> VALIDEE.
  Future<MaintenanceRequestModel> validate(String id) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>('/maintenance/$id/validate');
      return MaintenanceRequestModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// VALIDEE -> ASSIGNEE.
  Future<MaintenanceRequestModel> assign({
    required String id,
    required String assignedToId,
    DateTime? scheduledAt,
    num? estimatedCost,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>('/maintenance/$id/assign', data: {
        'assignedToId': assignedToId,
        if (scheduledAt != null) 'scheduledAt': scheduledAt.toIso8601String(),
        'estimatedCost': ?estimatedCost,
      });
      return MaintenanceRequestModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PaginatedResult<MaintenanceRequestModel>> assignedTo({
    required String userId,
    int page = 1,
    int limit = 20,
    MaintenanceStatus? status,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/maintenance', queryParameters: {
        'assignedToId': userId,
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

  /// The mobile field-manager flow only ever drives ASSIGNEE→EN_COURS
  /// (start) and EN_COURS→TERMINEE (finish); the rest of the state machine
  /// (NOUVELLE→VALIDEE→ASSIGNEE) is office-side. The UI enforces which
  /// action is offered at which status; the server enforces the transitions.
  Future<MaintenanceRequestModel> updateStatus({
    required String id,
    required MaintenanceStatus status,
    num? actualCost,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>('/maintenance/$id/status', data: {
        'status': status.name,
        'actualCost': ?actualCost,
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
          // MultipartFile.fromFile() reads via dart:io, unsupported on Flutter
          // Web (file.path there is a blob: URL, not a real filesystem path)
          // - fromBytes() works on every platform.
          for (final file in files)
            MultipartFile.fromBytes(await file.readAsBytes(), filename: file.name),
        ],
      });
      await _dio.post('/maintenance/$requestId/attachments', data: formData);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
