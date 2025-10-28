// lib/widgets/note_card.dart
import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback? onTap;
  NoteCard({required this.note, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
        title: Text(note.title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${note.subject} · ${note.semester} · ${note.teacherName}'),
        trailing: Chip(label: Text(note.importance)),
      ),
    );
  }
}
