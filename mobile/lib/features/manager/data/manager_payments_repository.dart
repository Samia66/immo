import 'package:dio/dio.dart';

import '../../../core/models/paginated_result.dart';
import '../../../core/models/payment_model.dart';
import '../../../core/network/api_exception.dart';

/// Manager-side payments: `GET /payments` is scoped server-side to this
/// manager's own leases - no client-side filtering needed. Also used for the
/// property/unit detail view's occupant + payments overview (`byUnit`,
/// `QueryPaymentDto.propertyUnitId` - unit-level, not a property-level id -
/// verified against the real backend DTO), and the "record payment" action.
class ManagerPaymentsRepository {
  ManagerPaymentsRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResult<PaymentModel>> byUnit(
    String propertyUnitId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/payments', queryParameters: {
        'propertyUnitId': propertyUnitId,
        'page': page,
        'limit': limit,
      });
      return PaginatedResult<PaymentModel>.fromJson(
        response.data!,
        (json) => PaymentModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PaginatedResult<PaymentModel>> list({
    int page = 1,
    int limit = 20,
    PaymentStatus? status,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/payments', queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.name,
      });
      return PaginatedResult<PaymentModel>.fromJson(
        response.data!,
        (json) => PaymentModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// `POST /payments/:id/record` - `data` follows the real
  /// `RecordPaymentDto`: `amountPaid`, `method`, `paidAt` required;
  /// `transactionRef` optional. `leaseId` is intentionally NOT part of this
  /// DTO (the target payment is already known from the path parameter).
  Future<PaymentModel> record(
    String id, {
    required num amountPaid,
    required PaymentMethod method,
    required DateTime paidAt,
    String? transactionRef,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/payments/$id/record', data: {
        'amountPaid': amountPaid,
        'method': method.name,
        'paidAt': paidAt.toIso8601String().split('T').first,
        if (transactionRef != null && transactionRef.isNotEmpty) 'transactionRef': transactionRef,
      });
      return PaymentModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
