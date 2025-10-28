// lib/screens/filter_result.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'student_note.dart';

class FilterResultScreen extends StatefulWidget {
  @override
  _FilterResultScreenState createState() => _FilterResultScreenState();
}

class _FilterResultScreenState extends State<FilterResultScreen> {
  String? _importance;
  String? _semester;
  List<NoteModel> _results = [];

  void _apply() async {
    final res = await Provider.of<NoteProvider>(context, listen: false).filter(importance: _importance, semester: _semester);
    setState(() { _results = res; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filter')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          DropdownButtonFormField<String>(
            value: _importance,
            items: [null, 'High', 'Moderate', 'Low'].map((e) => DropdownMenuItem(child: Text(e ?? 'Any'), value: e)).toList(),
            onChanged: (v) => setState(() { _importance = v; }),
            decoration: InputDecoration(labelText: 'Importance'),
          ),
          SizedBox(height: 8),
          TextField(decoration: InputDecoration(labelText: 'Semester (leave blank any)'), onChanged: (v) => _semester = v.isEmpty ? null : v),
          SizedBox(height: 12),
          ElevatedButton(onPressed: _apply, child: Text('Apply')),
          SizedBox(height: 12),
          Expanded(child: _results.isEmpty ? Center(child: Text('No results yet')) : ListView.builder(
            itemCount: _results.length,
            itemBuilder: (_, i) {
              final n = _results[i];
              return NoteCard(note: n, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StudentNoteScreen(note: n)));
              });
            },
          ))
        ]),
      ),
    );
  }
}
