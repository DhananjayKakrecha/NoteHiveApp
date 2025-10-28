// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/note_provider.dart';
import 'screens/main_screen.dart';
import 'screens/admin_home.dart';
import 'screens/admin_login.dart';
import 'screens/teacher_home.dart';
import 'screens/teacher_login.dart';
import 'screens/student_home.dart';
import 'screens/student_login.dart';
import 'screens/student_register.dart';
import 'utils/constants.dart';

void main() {
  runApp(NoteHiveApp());
}

class NoteHiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NoteHive',
        theme: ThemeData(
          // 🎨 Main color theme
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.primary,
            secondary: AppColors.accent,
          ),

          // 🟡 AppBar theme
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            iconTheme: IconThemeData(color: AppColors.blackText),
            titleTextStyle: TextStyle(
              color: AppColors.blackText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
            elevation: 4,
          ),

          // 🟡 Elevated buttons
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.blackText,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(120, 48),
            ),
          ),

          // 🟡 Text buttons and icons
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.blackText,
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.blackText),

          // 🟡 Text theme
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColors.blackText),
            bodyMedium: TextStyle(color: AppColors.blackText),
            titleLarge: TextStyle(
              color: AppColors.blackText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 🔗 Routes
        initialRoute: '/',
        routes: {
          '/': (_) => MainScreen(),
          '/admin-login': (_) => AdminLoginScreen(),
          '/admin-home': (_) => AdminHomeScreen(),
          '/teacher-login': (_) => TeacherLoginScreen(),
          '/teacher-home': (_) => TeacherHomeScreen(),
          '/student-login': (_) => StudentLoginScreen(),
          '/student-register': (_) => StudentRegisterScreen(),
          '/student-home': (_) => StudentHomeScreen(),
        },
      ),
    );
  }
}
