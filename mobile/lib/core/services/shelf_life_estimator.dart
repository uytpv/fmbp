import 'package:flutter/material.dart';

enum ShelfLifeStatus {
  safe,
  expiringSoon,
  expired,
}

class ShelfLifeEstimator {
  ShelfLifeEstimator._();

  /// Chuẩn hóa chuỗi tiếng Việt: bỏ dấu, viết thường, loại bỏ ký tự lạ
  static String _normalize(String input) {
    var str = input.toLowerCase().trim();
    const vietnameseMap = {
      'a': 'áàảãạăắằẳẵặâấầẩẫậ',
      'd': 'đ',
      'e': 'éèẻẽẹêếềểễệ',
      'i': 'íìỉĩị',
      'o': 'óòỏõọôốồổỗộơớờởỡợ',
      'u': 'úùủũụưứừửữự',
      'y': 'ýỳỷỹỵ',
    };

    vietnameseMap.forEach((nonAccent, accents) {
      for (int i = 0; i < accents.length; i++) {
        str = str.replaceAll(accents[i], nonAccent);
      }
    });

    return str;
  }

  /// Kiểm tra từ khóa: hỗ trợ cả cụm từ và từ đơn chính xác
  static bool _matchesWord(String text, String keyword) {
    if (keyword.contains(' ')) {
      return text.contains(keyword);
    }
    final words = text.split(RegExp(r'[\s,.-]+'));
    return words.contains(keyword);
  }

  static bool _matchesAny(String text, List<String> keywords) {
    for (final kw in keywords) {
      if (_matchesWord(text, kw)) return true;
    }
    return false;
  }

  /// Ước tính số ngày bảo quản dựa trên tên nguyên liệu và vị trí lưu trữ
  static int estimateShelfLifeDays(String itemName, String storageLocation) {
    final loc = storageLocation.toUpperCase();
    final name = _normalize(itemName);

    // 1. Bánh mì, bánh ngọt (Kiểm tra trước để 'bánh mì' không bị phân loại nhầm vào 'mì gói')
    if (_matchesAny(name, ['banh mi', 'sandwich', 'banh bao'])) {
      if (loc == 'FREEZER') return 30;
      if (loc == 'FRIDGE') return 7;
      return 3; // PANTRY
    }

    // 2. Trứng & Sữa (Kiểm tra trước để 'trứng gà' không bị gán nhầm sang 'thịt gà')
    if (_matchesAny(name, ['trung', 'trung ga', 'trung vit', 'trung cut'])) {
      if (loc == 'PANTRY') return 10;
      return 28; // FRIDGE
    }
    if (_matchesAny(name, ['sua chua', 'yogurt'])) {
      if (loc == 'PANTRY') return 1;
      return 15; // FRIDGE
    }
    if (_matchesAny(name, ['sua tuoi', 'sua dac', 'pho mai', 'cheese', 'bo sua', 'bo thuc vat', 'vang sua'])) {
      if (loc == 'FREEZER') return 90;
      if (loc == 'PANTRY') return 2;
      return 7; // FRIDGE
    }

    // 3. Đồ khô, mì gói, gia vị, đồ hộp (dùng cụm từ chính xác tránh nhầm: 'phở' với 'phô mai', 'tiêu' với 'chuối tiêu')
    if (_matchesAny(name, [
      'gao', 'mi', 'mi tom', 'mi goi', 'bun kho', 'mien kho', 'banh pho', 'pho kho',
      'dau an', 'nuoc mam', 'nuoc tuong', 'tuong ca', 'tuong ot', 'muoi', 'duong',
      'bot ngot', 'hat tieu', 'tieu den', 'hat nem', 'do hop', 'pate', 'ca hop',
      'bot mi', 'bot gao'
    ])) {
      return 180; // 6 tháng
    }

    // 4. Củ quả có chữ 'cà' (cà rốt, cà chua, cà tím) & khoai củ
    if (_matchesAny(name, [
      'ca rot', 'ca chua', 'ca tim', 'ca phao', 'khoai', 'khoai tay', 'khoai lang',
      'cu cai', 'cu den', 'hanh tay', 'toi', 'gung', 'sa', 'bi do', 'bi dao',
      'muop', 'bau', 'kho qua', 'ot chuong'
    ])) {
      if (loc == 'FREEZER') return 60;
      if (loc == 'PANTRY') return 10;
      return 14; // FRIDGE
    }

    // 5. Rau ăn lá, bắp cải, nấm tươi, giá đỗ, rau thơm
    if (_matchesAny(name, [
      'rau', 'cai', 'xa lach', 'muong', 'ngot', 'mong toi', 'den', 'tan o',
      'hanh la', 'ngo', 'thi la', 'rau thom', 'nam', 'gia do', 'dau cove',
      'dau que', 'bap cai', 'sup lo', 'bong cai', 'can tay'
    ])) {
      if (loc == 'FREEZER') return 30;
      if (loc == 'PANTRY') return 2;
      return 5; // FRIDGE
    }

    // 6. Trái cây tươi (bơ dùng 'qua bo', lê dùng 'qua le' để tránh trùng 'thịt bò' và 'phi lê')
    if (_matchesAny(name, [
      'chuoi', 'tao', 'cam', 'quyt', 'xoai', 'qua bo', 'trai bo', 'bo sap',
      'dua hau', 'qua le', 'trai le', 'nho', 'dau tay', 'thanh long', 'chom chom', 'sau rieng',
      'buoi', 'oi', 'man'
    ])) {
      if (loc == 'FREEZER') return 30;
      if (loc == 'PANTRY') return 4;
      return 7; // FRIDGE
    }

    // 7. Đậu phụ, đồ tươi từ đậu nành
    if (_matchesAny(name, ['dau hu', 'dau phu', 'tau hu', 'sua dau nanh'])) {
      if (loc == 'PANTRY') return 1;
      return 4; // FRIDGE
    }

    // 8. Thức ăn nấu chín, món ăn sẵn
    if (_matchesAny(name, ['com', 'canh', 'kho', 'xao', 'luoc', 'nuong', 'sot', 'sup', 'chao'])) {
      if (loc == 'FREEZER') return 30;
      if (loc == 'PANTRY') return 1;
      return 3; // FRIDGE
    }

    // 9. Thịt tươi, cá, hải sản
    if (_matchesAny(name, [
      'thit', 'bo', 'heo', 'lon', 'ga', 'vit', 'chim', 'ca', 'tom', 'muc',
      'cua', 'ngheu', 'so', 'oc', 'luon', 'cha lua', 'gio', 'xuc xich',
      'ba chi', 'suon', 'nam bo', 'bap bo', 'uc ga', 'canh ga', 'dui ga', 'file'
    ])) {
      if (loc == 'FREEZER') return 90;
      if (loc == 'PANTRY') return 1;
      return 3; // FRIDGE
    }

    // Mặc định an toàn nếu không nhận diện được
    if (loc == 'FREEZER') return 60;
    if (loc == 'PANTRY') return 7;
    return 5; // FRIDGE
  }

  /// Ước tính ngày hết hạn chính xác
  static DateTime estimateExpirationDate(
    String itemName,
    String storageLocation, {
    DateTime? fromDate,
  }) {
    final base = fromDate ?? DateTime.now();
    final days = estimateShelfLifeDays(itemName, storageLocation);
    return DateTime(base.year, base.month, base.day).add(Duration(days: days));
  }

  /// Lấy mẹo bảo quản thông minh
  static String getStorageTip(String itemName, String storageLocation) {
    final loc = storageLocation.toUpperCase();
    final name = _normalize(itemName);

    if (_matchesAny(name, ['thit', 'ca', 'tom', 'muc'])) {
      if (loc == 'FREEZER') return 'Nên chia nhỏ từng phần trước khi cấp đông.';
      return 'Bảo quản ngăn mát lạnh sâu, bọc kín tránh lẫn mùi.';
    }
    if (_matchesAny(name, ['rau', 'cai', 'xa lach', 'ngot'])) {
      return 'Không nên rửa trước khi cho vào tủ lạnh để tránh bị úng.';
    }
    if (_matchesAny(name, ['khoai tay', 'hanh tay', 'toi'])) {
      return 'Bảo quản nơi khô ráo thoáng mát, tránh ánh sáng trực tiếp.';
    }
    if (_matchesAny(name, ['chuoi'])) {
      return 'Nên bọc cuống chuối để làm chậm quá trình chín.';
    }

    if (loc == 'FREEZER') return 'Bọc kín màng thực phẩm để chống cháy đông.';
    if (loc == 'FRIDGE') return 'Bảo quản trong hộp kín hoặc túi zip.';
    return 'Để nơi thoáng mát, khô ráo.';
  }

  /// Phân loại trạng thái hạn sử dụng
  static ShelfLifeStatus getStatus(DateTime? expiredDate) {
    if (expiredDate == null) return ShelfLifeStatus.safe;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(expiredDate.year, expiredDate.month, expiredDate.day);

    final diff = target.difference(today).inDays;
    if (diff < 0) return ShelfLifeStatus.expired;
    if (diff <= 2) return ShelfLifeStatus.expiringSoon;
    return ShelfLifeStatus.safe;
  }

  /// Trả về số ngày còn lại (hoặc số ngày đã quá hạn nếu âm)
  static int getRemainingDays(DateTime? expiredDate) {
    if (expiredDate == null) return 999;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(expiredDate.year, expiredDate.month, expiredDate.day);
    return target.difference(today).inDays;
  }

  /// Chuỗi hiển thị ngắn gọn thông minh: "Còn 3 ngày", "Hết hạn hôm nay", "Quá hạn 1 ngày"
  static String formatRemainingDaysText(DateTime? expiredDate) {
    if (expiredDate == null) return '';
    final days = getRemainingDays(expiredDate);
    if (days < 0) {
      return 'Quá hạn ${-days} ngày';
    } else if (days == 0) {
      return 'Hết hạn hôm nay';
    } else if (days == 1) {
      return 'Còn 1 ngày (Dùng ngay)';
    } else {
      return 'Còn $days ngày';
    }
  }

  /// Màu sắc đại diện cho trạng thái hạn sử dụng
  static Color getStatusColor(ShelfLifeStatus status) {
    switch (status) {
      case ShelfLifeStatus.expired:
        return const Color(0xFFE53935); // Đỏ
      case ShelfLifeStatus.expiringSoon:
        return const Color(0xFFFB8C00); // Cam/Vàng cảnh báo
      case ShelfLifeStatus.safe:
        return const Color(0xFF43A047); // Xanh lá an toàn
    }
  }
}
