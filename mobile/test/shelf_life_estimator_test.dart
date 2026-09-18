import 'package:flutter_test/flutter_test.dart';
import 'package:fmbp/core/services/shelf_life_estimator.dart';

void main() {
  group('ShelfLifeEstimator Tests', () {
    test('Correctly estimates meats and seafood shelf life', () {
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Thịt thăn bò tươi', 'FRIDGE'), 3);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Thịt ba chỉ heo', 'FREEZER'), 90);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Cá hồi phi lê', 'FRIDGE'), 3);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Tôm sú', 'FREEZER'), 90);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Thịt gà', 'PANTRY'), 1);
    });

    test('Correctly estimates leafy vegetables and greens', () {
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Rau muống', 'FRIDGE'), 5);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Xà lách Đà Lạt', 'FRIDGE'), 5);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Bắp cải', 'FRIDGE'), 5);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Rau thơm', 'PANTRY'), 2);
    });

    test('Correctly estimates root vegetables and fruits', () {
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Khoai tây', 'FRIDGE'), 14);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Cà rốt', 'FRIDGE'), 14);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Hành tây', 'PANTRY'), 10);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Chuối tiêu', 'FRIDGE'), 7);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Táo đỏ', 'FRIDGE'), 7);
    });

    test('Correctly estimates dairy and eggs', () {
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Trứng gà Ba Huân', 'FRIDGE'), 28);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Sữa chua Vinamilk', 'FRIDGE'), 15);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Phô mai con bò cười', 'FREEZER'), 90);
    });

    test('Correctly estimates dry goods and pantry staples', () {
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Gạo ST25', 'PANTRY'), 180);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Mì Hảo Hảo', 'PANTRY'), 180);
      expect(ShelfLifeEstimator.estimateShelfLifeDays('Nước mắm Nam Ngư', 'PANTRY'), 180);
    });

    test('Calculates future expiration date accurately', () {
      final base = DateTime(2026, 9, 19);
      final exp = ShelfLifeEstimator.estimateExpirationDate('Thịt bò', 'FRIDGE', fromDate: base);
      expect(exp, DateTime(2026, 9, 22));
    });

    test('Identifies shelf life status correctly', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final safeDate = today.add(const Duration(days: 7));
      final soonDate = today.add(const Duration(days: 1));
      final todayDate = today;
      final expiredDate = today.subtract(const Duration(days: 2));

      expect(ShelfLifeEstimator.getStatus(safeDate), ShelfLifeStatus.safe);
      expect(ShelfLifeEstimator.getStatus(soonDate), ShelfLifeStatus.expiringSoon);
      expect(ShelfLifeEstimator.getStatus(todayDate), ShelfLifeStatus.expiringSoon);
      expect(ShelfLifeEstimator.getStatus(expiredDate), ShelfLifeStatus.expired);

      expect(ShelfLifeEstimator.formatRemainingDaysText(safeDate), 'Còn 7 ngày');
      expect(ShelfLifeEstimator.formatRemainingDaysText(soonDate), 'Còn 1 ngày (Dùng ngay)');
      expect(ShelfLifeEstimator.formatRemainingDaysText(todayDate), 'Hết hạn hôm nay');
      expect(ShelfLifeEstimator.formatRemainingDaysText(expiredDate), 'Quá hạn 2 ngày');
    });
  });
}
