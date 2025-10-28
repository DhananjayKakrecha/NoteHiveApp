// lib/screens/teacher_home.dart
import 'package:flutter/material.dart';
import 'package:notehive/screens/teacher_note.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'upload_note.dart';
import 'subject_notes.dart';
import 'teacher_search.dart';
import '../utils/constants.dart';

class TeacherHomeScreen extends StatefulWidget {
  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final notesProv = Provider.of<NoteProvider>(context, listen: false);
    if (auth.currentUser != null) {
      notesProv.loadByTeacher(auth.currentUser!.id!);
    } else {
      notesProv.loadAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final noteProv = Provider.of<NoteProvider>(context);
    final teacher = auth.currentUser;
    final subjects = <String>{};
    for (final n in noteProv.notes) subjects.add(n.subject);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Container(
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
          child: TextField(
            readOnly: true,
            onTap: () async {
              final q = await Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherSearchScreen()));
              if (q != null) {
                // handled inside search screen
              }
            },
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
        child: Column(children: [
          Align(alignment: Alignment.centerLeft, child: Text('Subjects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
          SizedBox(height: 8),
          if (subjects.isEmpty) Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No notes yet. Upload some!'))),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: subjects.map((s) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SubjectNotesScreen(subject: s)));
              },
              child: Chip(label: Text(s)),
            )).toList(),
          ),
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: noteProv.notes.length,
              itemBuilder: (_, i) {
                final n = noteProv.notes[i];
                return NoteCard(note: n, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherNoteScreen(note: n)));
                });
              },
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UploadNoteScreen()),
          );
        },
        backgroundColor: AppColors.primary, // Yellow color
        foregroundColor: AppColors.blackText, // Black icon
        child: Icon(Icons.upload_file),
      ),
    );
  }
}

