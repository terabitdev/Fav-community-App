import 'package:flutter/material.dart';

class PaymentProvider with ChangeNotifier {
  String? _selectedPaymentMethod;
  Map<String, bool> _switchStates = {};

  String? get selectedPaymentMethod => _selectedPaymentMethod;

  void selectPaymentMethod(String paymentMethodId) {
    _selectedPaymentMethod = paymentMethodId;
    notifyListeners();
  }

  bool isSelected(String paymentMethodId) {
    return _selectedPaymentMethod == paymentMethodId;
  }

  bool getSwitchState(String paymentMethodId) {
    return _switchStates[paymentMethodId] ?? false;
  }

  void toggleSwitch(String paymentMethodId, bool value) {
    _switchStates[paymentMethodId] = value;
    notifyListeners();
  }
}