// lib/screens/student_home.dart
import 'package:flutter/material.dart';
import 'package:notehive/screens/student_note.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import 'search_result.dart';
import '../utils/constants.dart';

class StudentHomeScreen extends StatefulWidget {
  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NoteProvider>(context, listen: false).loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final noteProv = Provider.of<NoteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Container(
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
          child: TextField(
            readOnly: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultScreen())),
            decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search notes...', border: InputBorder.none),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text('', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: noteProv.notes.length,
          itemBuilder: (_, i) {
            final n = noteProv.notes[i];
            return NoteCard(note: n, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentNoteScreen(note: n)));
            });
          },
        ),
      ),
    );
  }
}
