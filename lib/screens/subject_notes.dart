// lib/screens/subject_notes.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'teacher_note.dart';

class SubjectNotesScreen extends StatefulWidget {
  final String subject;
  SubjectNotesScreen({required this.subject});
  @override
  _SubjectNotesScreenState createState() => _SubjectNotesScreenState();
}

class _SubjectNotesScreenState extends State<SubjectNotesScreen> {
  List<NoteModel> _notes = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final all = await Provider.of<NoteProvider>(context, listen: false).search(widget.subject);
    // filter to teacher's notes only
    final mine = all.where((n) => n.subject == widget.subject && n.teacherId == auth.currentUser!.id).toList();
    setState(() { _notes = mine; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject)),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (_, i) {
          final n = _notes[i];
          return NoteCard(note: n, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherNoteScreen(note: n)));
          });
        },
      ),
    );
  }
}
