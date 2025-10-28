// lib/screens/admin_home.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../db/db_helper.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  List<UserModel> _teachers = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  void _loadTeachers() async {
    final t = await DBHelper().getTeachers();
    setState(() { _teachers = t; });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        actions: [
          TextButton.icon(
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text('Logout', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(children: [
                Text('Add New Teacher', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(height: 10),
                TextField(controller: _nameCtl, decoration: InputDecoration(labelText: 'Name')),
                SizedBox(height: 8),
                TextField(controller: _emailCtl, decoration: InputDecoration(labelText: 'Email')),
                SizedBox(height: 8),
                TextField(controller: _passCtl, decoration: InputDecoration(labelText: 'Password')),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    setState(() { _loading = true; });
                    final msg = await auth.addTeacher(_nameCtl.text.trim(), _emailCtl.text.trim(), _passCtl.text.trim());
                    setState(() { _loading = false; });
                    if (msg != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                    } else {
                      _nameCtl.clear(); _emailCtl.clear(); _passCtl.clear();
                      _loadTeachers();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Teacher added')));
                    }
                  },
                  child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Add Teacher'),
                )
              ]),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _teachers.isEmpty ? Center(child: Text('No teachers yet')) : ListView.builder(
              itemCount: _teachers.length,
              itemBuilder: (_, i) {
                final t = _teachers[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(t.name[0])),
                  title: Text(t.name),
                  subtitle: Text(t.email),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
