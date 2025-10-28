// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<String?> login(String email, String password, String role) async {
    final db = DBHelper();
    final u = await db.getUserByEmail(email);
    if (u == null) return 'No user found';
    if (u.password != password) return 'Wrong password';
    if (u.role != role) return 'Role mismatch';
    _currentUser = u;
    notifyListeners();
    return null;
  }

  Future<String?> registerStudent(String name, String email, String password) async {
    final db = DBHelper();
    final exists = await db.getUserByEmail(email);
    if (exists != null) return 'Email already used';
    final u = UserModel(name: name, email: email, password: password, role: UserRole.student);
    await db.insertUser(u);
    return null;
  }

  Future<String?> addTeacher(String name, String email, String password) async {
    final db = DBHelper();
    final exists = await db.getUserByEmail(email);
    if (exists != null) return 'Email already used';
    final u = UserModel(name: name, email: email, password: password, role: UserRole.teacher);
    await db.insertUser(u);
    return null;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
