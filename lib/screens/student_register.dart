// lib/screens/student_register.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class StudentRegisterScreen extends StatefulWidget {
  @override
  _StudentRegisterScreenState createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Student Register'), backgroundColor: AppColors.primary),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: _name, decoration: InputDecoration(labelText: 'Full name')),
          SizedBox(height: 8),
          TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
          SizedBox(height: 8),
          TextField(controller: _pass, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loading ? null : () async {
              setState(() { _loading = true; });
              final msg = await auth.registerStudent(_name.text.trim(), _email.text.trim(), _pass.text.trim());
              setState(() { _loading = false; });
              if (msg != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registered. Please login.')));
                Navigator.pop(context);
              }
            },
            child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Register'),
          )
        ]),
      ),
    );
  }
}
