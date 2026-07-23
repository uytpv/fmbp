import 'package:flutter_test/flutter_test.dart';
import 'package:fmbp/core/utils/math_evaluator.dart';

void main() {
  group('MathEvaluator Tests', () {
    test('Evaluates basic numbers', () {
      expect(MathEvaluator.tryEvaluate('20000000'), 20000000.0);
      expect(MathEvaluator.tryEvaluate(' 1500000 '), 1500000.0);
      expect(MathEvaluator.tryEvaluate('37.5'), 37.5);
    });

    test('Evaluates multiplication & division', () {
      expect(MathEvaluator.tryEvaluate('37.5*4*15'), 2250.0);
      expect(MathEvaluator.tryEvaluate('100 / 4'), 25.0);
      expect(MathEvaluator.tryEvaluate('50 x 2'), 100.0);
      expect(MathEvaluator.tryEvaluate('100 : 5'), 20.0);
    });

    test('Evaluates addition & subtraction with parentheses', () {
      expect(MathEvaluator.tryEvaluate('(500 + 200) * 4'), 2800.0);
      expect(MathEvaluator.tryEvaluate('100 - (20 + 30)'), 50.0);
      expect(MathEvaluator.tryEvaluate('10.5 + 4.5'), 15.0);
    });

    test('Handles invalid expressions gracefully', () {
      expect(MathEvaluator.tryEvaluate('abc'), null);
      expect(MathEvaluator.tryEvaluate('10 / 0'), null);
      expect(MathEvaluator.tryEvaluate('(10 + 5'), null);
    });
  });
}
