// lib/models/user.dart
class UserRole {
  static const admin = 'admin';
  static const teacher = 'teacher';
  static const student = 'student';
}

class UserModel {
  int? id;
  String name;
  String email;
  String password;
  String role; // admin/teacher/student

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
    id: m['id'],
    name: m['name'],
    email: m['email'],
    password: m['password'],
    role: m['role'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
