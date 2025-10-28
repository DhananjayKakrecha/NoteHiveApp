// lib/screens/admin_login.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailCtl = TextEditingController(text: 'admin@notehive.com');
  final _passCtl = TextEditingController(text: 'admin123');
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Admin Login'), backgroundColor: AppColors.primary),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          SizedBox(height: 24),
          TextField(controller: _emailCtl, decoration: InputDecoration(labelText: 'Email')),
          SizedBox(height: 12),
          TextField(controller: _passCtl, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          SizedBox(height: 18),
          if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loading ? null : () async {
              setState(() { _loading = true; _error = null; });
              final msg = await auth.login(_emailCtl.text.trim(), _passCtl.text.trim(), 'admin');
              setState(() { _loading = false; });
              if (msg != null) {
                setState(() { _error = msg; });
              } else {
                Navigator.pushReplacementNamed(context, '/admin-home');
              }
            },
            child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Login'),
          )
        ]),
      ),
    );
  }
}
