import 'package:intl/intl.dart';

class CurrencyFormatter {
  static num normalize(num amount, String currencyCode) {
    final curr = currencyCode.toUpperCase();
    if (curr == 'EUR' || curr == 'USD' || curr == 'GBP') {
      // Nếu số tiền > 500 khi tiền tệ là EUR/USD/GBP -> Đây là số VNĐ cũ (vd 57000 VNĐ), quy đổi tự động ra EUR (1 EUR ~ 26.500 VNĐ)
      if (amount > 500) {
        final converted = amount / 26500.0;
        return double.parse(converted.toStringAsFixed(2));
      }
    } else if (curr == 'VND') {
      // Nếu số tiền < 500 khi tiền tệ là VNĐ -> Đây là số EUR/USD (vd 82 EUR), quy đổi tự động ra VNĐ
      if (amount > 0 && amount < 500) {
        return (amount * 26500).round();
      }
    }
    return amount;
  }

  static String format(num amount, String currencyCode) {
    final cleanAmount = normalize(amount, currencyCode);
    switch (currencyCode.toUpperCase()) {
      case 'EUR':
        return '€${cleanAmount.toStringAsFixed(2)}';
      case 'USD':
        return '\$${cleanAmount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${cleanAmount.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${cleanAmount.toInt()}';
      case 'VND':
      default:
        final formatter = NumberFormat('#,###', 'vi_VN');
        return '${formatter.format(cleanAmount.toInt())} ₫';
    }
  }
}
