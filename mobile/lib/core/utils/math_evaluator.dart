class MathEvaluator {
  /// Thử tính toán biểu thức toán học (+, -, *, /, (, )).
  /// Trả về double nếu tính toán thành công, trả về null nếu biểu thức không hợp lệ.
  static double? tryEvaluate(String input) {
    final cleanInput = input.replaceAll(' ', '').trim();
    if (cleanInput.isEmpty) return null;

    // Nếu chỉ là số thông thường
    final directNum = double.tryParse(cleanInput);
    if (directNum != null) return directNum;

    try {
      final parser = _MathParser(cleanInput);
      final result = parser.parse();
      if (result.isNaN || result.isInfinite) return null;
      return result;
    } catch (_) {
      return null;
    }
  }
}

class _MathParser {
  final String input;
  int pos = 0;

  _MathParser(this.input);

  int get _ch => pos < input.length ? input.codeUnitAt(pos) : -1;

  void _eatChar() {
    pos++;
  }

  bool _match(int charToMatch) {
    if (_ch == charToMatch) {
      _eatChar();
      return true;
    }
    return false;
  }

  double parse() {
    final v = _parseExpression();
    if (pos < input.length) {
      throw FormatException('Unexpected character at $pos');
    }
    return v;
  }

  // Expression = Term { ("+" | "-") Term }
  double _parseExpression() {
    var v = _parseTerm();
    while (true) {
      if (_match(43)) { // '+'
        v += _parseTerm();
      } else if (_match(45)) { // '-'
        v -= _parseTerm();
      } else {
        break;
      }
    }
    return v;
  }

  // Term = Factor { ("*" | "/") Factor }
  double _parseTerm() {
    var v = _parseFactor();
    while (true) {
      if (_match(42) || _match(120) || _match(88)) { // '*', 'x', 'X'
        v *= _parseFactor();
      } else if (_match(47) || _match(58)) { // '/', ':'
        final divisor = _parseFactor();
        if (divisor == 0) throw Exception('Division by zero');
        v /= divisor;
      } else {
        break;
      }
    }
    return v;
  }

  // Factor = Number | "(" Expression ")" | "-" Factor | "+" Factor
  double _parseFactor() {
    if (_match(43)) { // '+'
      return _parseFactor();
    }
    if (_match(45)) { // '-'
      return -_parseFactor();
    }

    if (_match(40)) { // '('
      final v = _parseExpression();
      if (!_match(41)) { // ')'
        throw FormatException('Missing closing parenthesis');
      }
      return v;
    }

    final startPos = pos;
    var hasDecimal = false;

    while (pos < input.length) {
      final c = input.codeUnitAt(pos);
      if ((c >= 48 && c <= 57)) { // '0'-'9'
        pos++;
      } else if (c == 46 || c == 44) { // '.' or ','
        if (hasDecimal) break;
        hasDecimal = true;
        pos++;
      } else {
        break;
      }
    }

    if (startPos == pos) {
      throw FormatException('Expected number at $pos');
    }

    final numStr = input.substring(startPos, pos).replaceAll(',', '.');
    final number = double.tryParse(numStr);
    if (number == null) throw FormatException('Invalid number');
    return number;
  }
}
