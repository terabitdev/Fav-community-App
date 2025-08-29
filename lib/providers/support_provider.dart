import 'package:flutter/material.dart';

class SupportProvider with ChangeNotifier {
  int _rating = 0;

  int get rating => _rating;

  void setRating(int rating) {
    _rating = rating;
    notifyListeners();
  }

  void clearRating() {
    _rating = 0;
    notifyListeners();
  }
}