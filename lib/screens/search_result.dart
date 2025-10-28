// lib/screens/search_result.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'student_note.dart';
import 'filter_result.dart';

class SearchResultScreen extends StatefulWidget {
  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
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
          decoration: InputDecoration(hintText: 'Search subject, title, teacher', border: InputBorder.none),
        ),
        actions: [
          IconButton(icon: Icon(Icons.filter_list), onPressed: () async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => FilterResultScreen()));
            if (result != null) setState(() { _results = result; });
          })
        ],
      ),
      body: _results.isEmpty ? Center(child: Text('No results')) : ListView.builder(
        itemCount: _results.length,
        itemBuilder: (_, i) {
          final n = _results[i];
          return NoteCard(note: n, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => StudentNoteScreen(note: n)));
          });
        },
      ),
    );
  }
}
