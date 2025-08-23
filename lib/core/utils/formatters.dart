import 'package:flutter/services.dart';

/// Formats phone number to (555) 555-1234 while typing
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    var newText = '';
    if (digits.length >= 1) {
      newText = '(${digits.substring(0, digits.length.clamp(0, 3))}';
    }
    if (digits.length > 3) {
      newText += ') ${digits.substring(3, digits.length.clamp(3, 6))}';
    }
    if (digits.length > 6) {
      newText += '-${digits.substring(6, digits.length.clamp(6, 10))}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
