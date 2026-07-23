import 'package:flutter/foundation.dart';

class AppConfig {
  /// Xác định host IP chuẩn xác cho từng môi trường:
  /// 1. Nếu là Web (kIsWeb): LUÔN LUÔN dùng 'localhost' (khắc phục lỗi Chrome Web)
  /// 2. Nếu là Android (defaultTargetPlatform == TargetPlatform.android): dùng '10.0.2.2' cho AVD Emulator
  /// 3. Tất cả nền tảng khác (Windows/macOS/Linux): 'localhost'
  static String get localHost {
    if (kIsWeb) {
      return 'localhost';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return '10.0.2.2';
    }
    return 'localhost';
  }
}
