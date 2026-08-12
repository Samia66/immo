import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

// ignore_for_file: constant_identifier_names

enum PaymentStatus { EN_ATTENTE, PARTIEL, PAYE, EN_RETARD, ANNULE }

enum PaymentMethod { ESPECES, VIREMENT, MOBILE_MONEY, CHEQUE, CARTE }

extension PaymentStatusLabel on PaymentStatus {
  String get label => switch (this) {
        PaymentStatus.EN_ATTENTE => 'En attente',
        PaymentStatus.PARTIEL => 'Partiel',
        PaymentStatus.PAYE => 'Payé',
        PaymentStatus.EN_RETARD => 'En retard',
        PaymentStatus.ANNULE => 'Annulé',
      };
}

extension PaymentMethodLabel on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.ESPECES => 'Espèces',
        PaymentMethod.VIREMENT => 'Virement',
        PaymentMethod.MOBILE_MONEY => 'Mobile Money',
        PaymentMethod.CHEQUE => 'Chèque',
        PaymentMethod.CARTE => 'Carte',
      };
}

/// Full Payment record, as returned by `/payments/me`, `/payments/:id`, etc.
@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String leaseId,
    required num amountDue,
    required num amountPaid,
    required DateTime dueDate,
    DateTime? paidAt,
    num? lateFee,
    PaymentMethod? method,
    String? transactionRef,
    required PaymentStatus status,
    String? receiptUrl,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}

extension PaymentModelX on PaymentModel {
  num get balanceDue => amountDue - amountPaid;
}

/// Lighter payment shape embedded in `GET /dashboard/tenant`
/// (`nextPayment` / `recentPayments`): only id/amountDue/amountPaid/dueDate/status,
/// no paidAt/lateFee/method/transactionRef/receiptUrl.
@freezed
class PaymentSummaryModel with _$PaymentSummaryModel {
  const factory PaymentSummaryModel({
    required String id,
    required num amountDue,
    required num amountPaid,
    required DateTime dueDate,
    required PaymentStatus status,
  }) = _PaymentSummaryModel;

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryModelFromJson(json);
}
