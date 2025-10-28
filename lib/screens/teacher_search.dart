// lib/screens/teacher_search.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'teacher_note.dart';

class TeacherSearchScreen extends StatefulWidget {
  @override
  _TeacherSearchScreenState createState() => _TeacherSearchScreenState();
}

class _TeacherSearchScreenState extends State<TeacherSearchScreen> {
  final _qCtl = TextEditingController();
  List<NoteModel> _results = [];

  void _search(String q) async {
    final res = await Provider.of<NoteProvider>(context, listen: false).search(q);
    setState(() { _results = res; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _qCtl,
          onChanged: (v) => _search(v),
          decoration: InputDecoration(hintText: 'Search by subject, title or teacher', border: InputBorder.none),
        ),
      ),
      body: _results.isEmpty ? Center(child: Text('No results')) : ListView.builder(
        itemCount: _results.length,
        itemBuilder: (_, i) {
          final n = _results[i];
          return NoteCard(note: n, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherNoteScreen(note: n)));
          });
        },
      ),
    );
  }
}
