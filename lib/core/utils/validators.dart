class AppValidators {
  // ---------------------- Email ----------------------
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  // ---------------------- Phone ----------------------
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    final phoneRegex = RegExp(r'^\(\d{3}\)\s\d{3}-\d{4}$');
    if (!phoneRegex.hasMatch(value)) {
      return "Enter phone as (555) 555-1234";
    }
    return null;
  }

  // ---------------------- Password ----------------------
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return "Password must contain at least 1 letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least 1 number";
    }
    return null;
  }

  // ---------------------- Confirm Password ----------------------
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  // ---------------------- Name ----------------------
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Full name is required";
    }
    if (value.length < 2) {
      return "Enter a valid name";
    }
    return null;
  }
}
