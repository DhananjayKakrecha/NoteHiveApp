// lib/screens/student_login.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class StudentLoginScreen extends StatefulWidget {
  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Student Login'), backgroundColor: AppColors.primary),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
          SizedBox(height: 8),
          TextField(controller: _pass, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          SizedBox(height: 12),
          if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
          Row(
            children: [
              ElevatedButton(
                onPressed: _loading ? null : () async {
                  setState(() { _loading = true; _error = null; });
                  final msg = await auth.login(_email.text.trim(), _pass.text.trim(), 'student');
                  setState(() { _loading = false; });
                  if (msg != null) setState(() { _error = msg; });
                  else Navigator.pushReplacementNamed(context, '/student-home');
                },
                child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Login'),
              ),
              SizedBox(width: 12),
              TextButton(onPressed: () => Navigator.pushNamed(context, '/student-register'), child: Text('Register'))
            ],
          )
        ]),
      ),
    );
  }
}
