import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currency_service.g.dart';

class CurrencyInfo {
  final String code;
  final String symbol;
  final String name;
  final String flag;

  const CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.name,
    required this.flag,
  });
}

class CurrencyService {
  final Dio _dio;

  // 10 Đơn vị tiền tệ phổ biến
  static const List<CurrencyInfo> supportedCurrencies = [
    CurrencyInfo(code: 'VND', symbol: '₫', name: 'Việt Nam Đồng', flag: '🇻🇳'),
    CurrencyInfo(code: 'USD', symbol: '\$', name: 'US Dollar', flag: '🇺🇸'),
    CurrencyInfo(code: 'EUR', symbol: '€', name: 'Euro', flag: '🇪🇺'),
    CurrencyInfo(code: 'JPY', symbol: '¥', name: 'Japanese Yen', flag: '🇯🇵'),
    CurrencyInfo(code: 'GBP', symbol: '£', name: 'British Pound', flag: '🇬🇧'),
    CurrencyInfo(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar', flag: '🇦🇺'),
    CurrencyInfo(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar', flag: '🇨🇦'),
    CurrencyInfo(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar', flag: '🇸🇬'),
    CurrencyInfo(code: 'KRW', symbol: '₩', name: 'South Korean Won', flag: '🇰🇷'),
    CurrencyInfo(code: 'CNY', symbol: '¥', name: 'Chinese Yuan', flag: '🇨🇳'),
  ];

  // Tỷ giá quy đổi quy chuẩn mặc định (Offline Fallback Rates - So với 1 VND)
  Map<String, double> _ratesFromVND = {
    'VND': 1.0,
    'USD': 0.000039,
    'EUR': 0.000036,
    'JPY': 0.0061,
    'GBP': 0.000031,
    'AUD': 0.000059,
    'CAD': 0.000054,
    'SGD': 0.000053,
    'KRW': 0.054,
    'CNY': 0.00028,
  };

  CurrencyService() : _dio = Dio() {
    _fetchRatesOnline();
  }

  /// Tải tỷ giá trực tuyến từ API miễn phí (open.er-api.com)
  Future<void> _fetchRatesOnline() async {
    try {
      final response = await _dio.get('https://open.er-api.com/v6/latest/VND');
      if (response.statusCode == 200 && response.data['rates'] != null) {
        final rates = response.data['rates'] as Map<String, dynamic>;
        rates.forEach((key, value) {
          if (value is num) {
            _ratesFromVND[key] = value.toDouble();
          }
        });
      }
    } catch (_) {
      // Giữ nguyên fallback rates nếu máy offline
    }
  }

  /// Chuyển đổi số tiền từ một đồng tiền sang VND
  double convertToVND(double amount, String fromCurrency) {
    if (fromCurrency == 'VND') return amount;
    final rate = _ratesFromVND[fromCurrency] ?? 1.0;
    if (rate == 0) return amount;
    return amount / rate;
  }

  /// Chuyển đổi từ VND sang đồng tiền được chọn
  double convertFromVND(double amountVND, String toCurrency) {
    if (toCurrency == 'VND') return amountVND;
    final rate = _ratesFromVND[toCurrency] ?? 1.0;
    return amountVND * rate;
  }

  /// Chuyển đổi số tiền trực tiếp từ currency A sang currency B theo tỷ giá
  double convert(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;
    final amountVND = convertToVND(amount, fromCurrency);
    return convertFromVND(amountVND, toCurrency);
  }

  /// Lấy ký hiệu tiền tệ (symbol) theo mã currency
  String getSymbol(String currencyCode) {
    final info = supportedCurrencies.firstWhere(
      (c) => c.code == currencyCode,
      orElse: () => supportedCurrencies[0],
    );
    return info.symbol;
  }

  /// Định dạng số tiền đẹp mắt theo từng currency
  String format(num amount, String currencyCode) {
    final info = supportedCurrencies.firstWhere(
      (c) => c.code == currencyCode,
      orElse: () => supportedCurrencies[0],
    );

    if (currencyCode == 'VND') {
      final formatter = NumberFormat('#,###', 'vi_VN');
      return '${formatter.format(amount)} ${info.symbol}';
    } else if (currencyCode == 'JPY' || currencyCode == 'KRW') {
      final formatter = NumberFormat('#,###', 'en_US');
      return '${info.symbol}${formatter.format(amount)}';
    } else {
      final formatter = NumberFormat('#,##0.00', 'en_US');
      return '${info.symbol}${formatter.format(amount)}';
    }
  }
}

@riverpod
CurrencyService currencyService(ref) {
  return CurrencyService();
}
