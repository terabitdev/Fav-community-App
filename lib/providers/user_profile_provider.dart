import 'dart:typed_data';
import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  bool _isLocationSharingEnabled = true;
  bool _isPushNotificationsEnabled = false;
  Uint8List? _profileImage;

  bool get isLocationSharingEnabled => _isLocationSharingEnabled;
  bool get isPushNotificationsEnabled => _isPushNotificationsEnabled;
  Uint8List? get profileImage => _profileImage;

  void toggleLocationSharing(bool value) {
    _isLocationSharingEnabled = value;
    notifyListeners();
  }

  void togglePushNotifications(bool value) {
    _isPushNotificationsEnabled = value;
    notifyListeners();
  }

  void setProfileImage(Uint8List? image) {
    _profileImage = image;
    notifyListeners();
  }
}