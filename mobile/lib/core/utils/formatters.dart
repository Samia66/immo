import 'package:intl/intl.dart';

/// Currency/date formatting helpers. The backend doesn't expose a currency
/// code in the contract given, so we default to XOF (West African CFA franc,
/// the currency implied by amount conventions in the spec's domain) with a
/// generic-enough format that still reads fine for any currency figure.
class Formatters {
  Formatters._();

  static final NumberFormat _amount = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'F CFA',
    decimalDigits: 0,
  );

  static final DateFormat _date = DateFormat('dd/MM/yyyy', 'fr_FR');
  static final DateFormat _dateTime = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR');
  static final DateFormat _time = DateFormat('HH:mm', 'fr_FR');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy', 'fr_FR');

  static String amount(num value) => _amount.format(value);

  static String date(DateTime? value) => value == null ? '-' : _date.format(value.toLocal());

  static String dateTime(DateTime? value) =>
      value == null ? '-' : _dateTime.format(value.toLocal());

  static String time(DateTime? value) => value == null ? '-' : _time.format(value.toLocal());

  static String monthYear(DateTime? value) =>
      value == null ? '-' : _monthYear.format(value.toLocal());

  static String relativeDay(DateTime? value) {
    if (value == null) return '-';
    final now = DateTime.now();
    final local = value.toLocal();
    final diff = DateTime(local.year, local.month, local.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diff == 0) return "Aujourd'hui";
    if (diff == 1) return 'Demain';
    if (diff == -1) return 'Hier';
    if (diff > 1 && diff <= 7) return 'Dans $diff jours';
    if (diff < -1 && diff >= -7) return 'Il y a ${-diff} jours';
    return date(value);
  }
}
