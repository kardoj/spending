import 'package:flutter/services.dart';

class MoneyInputFormatter implements TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // We accept only the dot, but let's convert comma to a dot for convenience.
    final newValueWithCommaReplaced = _replaceCommaWithDot(newValue);

    return RegExp(r'^(\d+)(\.?)(\d{1,2})?$').hasMatch(newValueWithCommaReplaced.text)
      ? newValueWithCommaReplaced
      : oldValue;
  }

  TextEditingValue _replaceCommaWithDot(TextEditingValue value)
    => TextEditingValue(
      text: value.text.replaceAll(',', '.'),
      selection: value.selection,
      composing: value.composing);
}