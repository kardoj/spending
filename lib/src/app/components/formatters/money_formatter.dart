import 'package:decimal/decimal.dart';

class MoneyFormatter {
  static format(Decimal amount) {
    return amount.toStringAsFixed(2);
  }
}