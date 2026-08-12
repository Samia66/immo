import 'package:dio/dio.dart';

/// Normalized error thrown by repositories after unwrapping a [DioException],
/// so presentation code can show a friendly message without knowing about Dio.
class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.isNetworkError = false,
  });

  factory ApiException.fromDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiException(
        message: 'Impossible de contacter le serveur. Vérifiez votre connexion.',
        isNetworkError: true,
      );
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    String? serverMessage;
    if (data is Map) {
      final msg = data['message'];
      if (msg is String) {
        serverMessage = msg;
      } else if (msg is List && msg.isNotEmpty) {
        serverMessage = msg.map((m) => m.toString()).join('\n');
      }
    }

    switch (statusCode) {
      case 401:
        return ApiException(
          message: serverMessage ?? 'Session expirée, veuillez vous reconnecter.',
          statusCode: statusCode,
        );
      case 403:
        return ApiException(
          message: serverMessage ?? "Vous n'avez pas les droits pour cette action.",
          statusCode: statusCode,
        );
      case 404:
        return ApiException(
          message: serverMessage ?? 'Ressource introuvable.',
          statusCode: statusCode,
        );
      case 422:
      case 400:
        return ApiException(
          message: serverMessage ?? 'Requête invalide.',
          statusCode: statusCode,
        );
      default:
        return ApiException(
          message: serverMessage ?? 'Une erreur est survenue. Veuillez réessayer.',
          statusCode: statusCode,
        );
    }
  }

  final String message;
  final int? statusCode;
  final bool isNetworkError;

  @override
  String toString() => message;
}
