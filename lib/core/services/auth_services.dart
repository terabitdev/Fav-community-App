import 'package:fava/data/mock/mock_auth_data.dart';
import 'package:fava/models/user.dart';

class AuthService {
  // ---------------------- SIGN UP ----------------------
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check if user already exists
    final existingUser = mockUsers.firstWhere(
      (u) => u.email == email,
      orElse: () => UserModel(
        id: '',
        fullName: '',
        email: '',
        phoneNumber: '',
        password: '',
      ),
    );

    if (existingUser.id.isNotEmpty) {
      throw Exception("User already exists with this email.");
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );

    mockUsers.add(newUser);
    return newUser;
  }

  // ---------------------- LOGIN ----------------------
  Future<UserModel> login({
    required String email,
    required String password, required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = mockUsers.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      return user;
    } catch (_) {
      throw Exception("Invalid email or password.");
    }
  }

  // ---------------------- FORGOT PASSWORD ----------------------
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    final exists = mockUsers.any((u) => u.email == email);

    if (!exists) {
      throw Exception("No account found with this email.");
    }

    // Mock behavior: Just pretend reset email is sent
    return;
  }
}
