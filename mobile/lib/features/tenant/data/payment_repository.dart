import 'package:dio/dio.dart';

import '../../../core/models/paginated_result.dart';
import '../../../core/models/payment_model.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/receipt_saver.dart';

/// Result of a receipt download attempt - see [PaymentRepository.downloadReceipt].
sealed class ReceiptResult {
  const ReceiptResult();
}

class ReceiptFileReady extends ReceiptResult {
  const ReceiptFileReady(this.filePath);

  /// Null on web: the browser's own download UI was already triggered
  /// directly, there's no local file path left to open.
  final String? filePath;
}

/// The backend's PDF generator is currently a stub (per the task brief) and
/// may return a JSON placeholder instead of a real PDF - surfaced distinctly
/// so the UI can show "receipt not yet available" instead of a broken file.
class ReceiptNotAvailable extends ReceiptResult {
  const ReceiptNotAvailable();
}

class PaymentRepository {
  PaymentRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResult<PaymentModel>> myPayments({
    int page = 1,
    int limit = 20,
    PaymentStatus? status,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/payments/me', queryParameters: {
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

  Future<PaymentModel> getPayment(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/payments/$id');
      return PaymentModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Downloads `/payments/:id/receipt.pdf`. The backend's PDF generator is a
  /// stub at this point in the project (per the task brief), so the response
  /// may either be a real PDF or a JSON placeholder - we inspect the
  /// content-type to tell them apart rather than assuming a real PDF.
  Future<ReceiptResult> downloadReceipt(String paymentId) async {
    try {
      final response = await _dio.get<List<int>>(
        '/payments/$paymentId/receipt.pdf',
        options: Options(responseType: ResponseType.bytes),
      );
      final contentType = response.headers.value('content-type') ?? '';
      final bytes = response.data;
      if (bytes == null || !contentType.contains('pdf')) {
        return const ReceiptNotAvailable();
      }
      final filePath = await saveReceiptBytes(bytes, 'quittance_$paymentId.pdf');
      return ReceiptFileReady(filePath);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
