// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/google-keep.png',
                    width: 140,
                    height: 140,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'NoteHive',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackText,
                  ),
                ),
                const SizedBox(height: 24),
                _roleButton(context, 'Admin', '/admin-login', Icons.admin_panel_settings),
                const SizedBox(height: 12),
                _roleButton(context, 'Teacher', '/teacher-login', Icons.school),
                const SizedBox(height: 12),
                _roleButton(context, 'Student', '/student-login', Icons.person),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleButton(BuildContext ctx, String label, String route, IconData icon) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.blackText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => Navigator.pushNamed(ctx, route),
      icon: Icon(icon, color: AppColors.blackText),
      label: Text('Login as $label'),
    );
  }
}
