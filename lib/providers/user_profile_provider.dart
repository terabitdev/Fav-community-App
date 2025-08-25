import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  bool _isLocationSharingEnabled = true;
  bool _isPushNotificationsEnabled = false;

  bool get isLocationSharingEnabled => _isLocationSharingEnabled;
  bool get isPushNotificationsEnabled => _isPushNotificationsEnabled;

  void toggleLocationSharing(bool value) {
    _isLocationSharingEnabled = value;
    notifyListeners();
  }

  void togglePushNotifications(bool value) {
    _isPushNotificationsEnabled = value;
    notifyListeners();
  }
}