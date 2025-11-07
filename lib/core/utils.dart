import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.simpleCurrency(locale: 'de_DE');
final _timeFormatter = DateFormat.Hm('de_DE');
final _weekdayFormatter = DateFormat.E('de_DE');

String formatCurrency(double value) => _currencyFormatter.format(value);

String formatSlot(DateTime slot) {
  final day = _weekdayFormatter.format(slot);
  final time = _timeFormatter.format(slot);
  return '$day, $time';
}

String describePizzaSize(double size) {
  switch (size.toInt()) {
    case 26:
      return '26 cm';
    case 30:
      return '30 cm';
    case 34:
      return '34 cm';
    default:
      return '${size.toStringAsFixed(0)} cm';
  }
}
