import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(num amount, String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${amount.toInt()}';
      case 'VND':
      default:
        final formatter = NumberFormat('#,###', 'vi_VN');
        return '${formatter.format(amount.toInt())} ₫';
    }
  }
}
