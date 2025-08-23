import 'dart:convert';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String? profileImage;
  final bool locationEnabled;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.profileImage,
    this.locationEnabled = false,
  });

  // Convert UserModel → Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'profileImage': profileImage,
      'locationEnabled': locationEnabled,
    };
  }

  // Convert Map → UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      password: map['password'] ?? '',
      profileImage: map['profileImage'],
      locationEnabled: map['locationEnabled'] ?? false,
    );
  }

  // JSON Encode
  String toJson() => json.encode(toMap());

  // JSON Decode
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
