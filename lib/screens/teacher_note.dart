// lib/screens/teacher_note.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'upload_note.dart';

class TeacherNoteScreen extends StatelessWidget {
  final NoteModel note;
  TeacherNoteScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    final noteProv = Provider.of<NoteProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // helper to show a confirmation dialog
    Future<bool?> _confirmDelete() {
      return showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.blackText,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(note.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('Subject: ${note.subject}  •  Semester: ${note.semester}'),
            const SizedBox(height: 8),
            Text('Teacher: ${note.teacherName}'),
            const SizedBox(height: 8),
            Text('Importance: ${note.importance}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            // Delete button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  final confirmed = await _confirmDelete();
                  if (confirmed != true) return;

                  // If no logged-in user, fallback to reloading all (but usually teacher is logged in)
                  final teacherId = auth.currentUser?.id;

                  // delete and reload only that teacher's notes
                  if (note.id != null) {
                    await noteProv.deleteNote(note.id!, teacherId: teacherId);
                  }

                  // Navigate back to teacher home and replace current route so home is re-created
                  Navigator.pushReplacementNamed(context, '/teacher-home');
                },
              ),
            ),

            const SizedBox(height: 8),

            // Update button (navigates to Upload screen — consider passing note to prefill)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Update'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.blackText,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UploadNoteScreen(noteToEdit: note)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
