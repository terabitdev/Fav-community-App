import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  late PageController _pageController;
  AnimationController? _floatController;

  NavProvider() {
    _pageController = PageController();
  }

  int get selectedIndex => _selectedIndex;
  PageController get pageController => _pageController;
  AnimationController? get floatController => _floatController;

  void setFloatController(AnimationController controller) {
    _floatController = controller;
  }

  void animateToPage(int index) {
    _selectedIndex = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}