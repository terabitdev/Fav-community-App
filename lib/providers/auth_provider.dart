import 'package:flutter/material.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  failure,
}

class AuthProvider extends ChangeNotifier {
  // Authentication state
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // Getters
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _status == AuthStatus.loading;

  // Clear error message
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Clear all states (including loading)
  void clearState() {
    _status = AuthStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  // Login functionality - only called after successful form validation
  Future<bool> login({
    required String email,
    required String password,
    bool enableLocation = false,
  }) async {
    try {
      // Clear any previous errors first
      _errorMessage = null;
      _setStatus(AuthStatus.loading);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate different login scenarios
      if (email == "test@example.com" && password == "password123") {
        // Simulate successful login
        _isLoggedIn = true;
        _setStatus(AuthStatus.success);
        return true;
      } else {
        // Simulate failed login
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      _setStatus(AuthStatus.failure);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoggedIn = false;
      return false;
    }
  }

  // Forgot Password functionality - sends reset code to email
  Future<bool> sendPasswordReset({required String email}) async {
    try {
      // Clear any previous errors first
      _errorMessage = null;
      _setStatus(AuthStatus.loading);

      // Simulate API call to send password reset email
      await Future.delayed(const Duration(seconds: 2));

      // Simulate different scenarios based on email
      if (email == "nonexistent@example.com") {
        // Simulate email not found
        throw Exception('No account found with this email address');
      } else if (email == "blocked@example.com") {
        // Simulate rate limiting or blocked email
        throw Exception('Too many password reset attempts. Please try again later');
      } else {
        // Simulate successful password reset email sent
        _setStatus(AuthStatus.success);
        return true;
      }
    } catch (e) {
      _setStatus(AuthStatus.failure);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    }
  }

  // Set New Password functionality - validates and sets new password
  Future<bool> setNewPassword({
    required String password,
    required String confirmPassword,
    String? resetToken, // In real app, this would be from the reset link
  }) async {
    try {
      // Clear any previous errors first
      _errorMessage = null;
      _setStatus(AuthStatus.loading);

      // Simulate API call to set new password
      await Future.delayed(const Duration(seconds: 2));

      // Simulate different scenarios
      if (resetToken == "expired_token") {
        // Simulate expired or invalid reset token
        throw Exception('Password reset link has expired. Please request a new one');
      } else if (password == "weak123") {
        // Simulate password policy violation
        throw Exception('Password does not meet security requirements');
      } else {
        // Simulate successful password reset
        _setStatus(AuthStatus.success);
        return true;
      }
    } catch (e) {
      _setStatus(AuthStatus.failure);
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    }
  }

  // Logout functionality
  void logout() {
    _isLoggedIn = false;
    _status = AuthStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  // Reset auth state
  void reset() {
    _status = AuthStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  // Private helper to set status
  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }
}