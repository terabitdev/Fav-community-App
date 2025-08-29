import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  bool _notificationsEnabled = true;
  Map<String, bool> _specificNotifications = {};

  bool get notificationsEnabled => _notificationsEnabled;

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  bool getNotificationState(String notificationId) {
    return _specificNotifications[notificationId] ?? true;
  }

  void toggleSpecificNotification(String notificationId, bool value) {
    _specificNotifications[notificationId] = value;
    notifyListeners();
  }
}