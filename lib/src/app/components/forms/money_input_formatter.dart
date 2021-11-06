import 'package:flutter/services.dart';

class MoneyInputFormatter implements TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    return RegExp(r'^(\d+)(\.?)(\d{1,2})?$').hasMatch(newValue.text) ? newValue : oldValue;
  }
}