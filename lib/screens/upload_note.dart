// lib/screens/upload_note.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';
import '../utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class UploadNoteScreen extends StatefulWidget {
  final NoteModel? noteToEdit; // if provided -> update mode

  const UploadNoteScreen({Key? key, this.noteToEdit}) : super(key: key);

  @override
  _UploadNoteScreenState createState() => _UploadNoteScreenState();
}

class _UploadNoteScreenState extends State<UploadNoteScreen> {
  final _titleCtl = TextEditingController();
  final _semesterCtl = TextEditingController();
  final _subjectCtl = TextEditingController();
  String _importance = 'Moderate';
  String? _filePath; // actual path stored (copied to app dir)
  bool _loading = false;
  bool _pickedNewFile = false; // true when teacher chooses new file while editing

  @override
  void initState() {
    super.initState();
    // If in edit mode, prefill fields
    final edit = widget.noteToEdit;
    if (edit != null) {
      _titleCtl.text = edit.title;
      _semesterCtl.text = edit.semester ?? '';
      _subjectCtl.text = edit.subject;
      _importance = edit.importance ?? 'Moderate';
      _filePath = edit.filePath; // keep existing file path unless replaced
    }
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _semesterCtl.dispose();
    _subjectCtl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      final src = File(result.files.single.path!);
      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${p.basename(src.path)}';
      final dest = File('${dir.path}/$fileName');
      await dest.writeAsBytes(await src.readAsBytes());
      setState(() {
        _filePath = dest.path;
        _pickedNewFile = true;
      });
    }
  }

  Future<void> _submit() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final noteProv = Provider.of<NoteProvider>(context, listen: false);

    if (_titleCtl.text.trim().isEmpty ||
        _subjectCtl.text.trim().isEmpty ||
        _filePath == null ||
        auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields and pick a file')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final isEdit = widget.noteToEdit != null;

      if (isEdit) {
        // Update existing note
        final updated = widget.noteToEdit!.copyWith(
          title: _titleCtl.text.trim(),
          semester: _semesterCtl.text.trim(),
          subject: _subjectCtl.text.trim(),
          filePath: _filePath!, // either original or newly picked
          importance: _importance,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );

        await noteProv.updateNote(updated, teacherId: auth.currentUser!.id);
        // After update, navigate back to teacher home so it reloads teacher notes
        Navigator.pushReplacementNamed(context, '/teacher-home');
      } else {
        // Create new note
        final newNote = NoteModel(
          title: _titleCtl.text.trim(),
          semester: _semesterCtl.text.trim(),
          subject: _subjectCtl.text.trim(),
          filePath: _filePath!,
          importance: _importance,
          teacherId: auth.currentUser!.id!,
          teacherName: auth.currentUser!.name,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );

        await noteProv.addNote(newNote, teacherId: auth.currentUser!.id);
        Navigator.pop(context); // return to teacher home (which will be updated)
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.noteToEdit != null;
    final yellow = AppColors.primary;
    final black = AppColors.blackText;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Update Note' : 'Upload Note'),
        backgroundColor: yellow,
        foregroundColor: black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleCtl,
                decoration: const InputDecoration(labelText: 'Title *', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _semesterCtl,
                decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _subjectCtl,
                decoration: const InputDecoration(labelText: 'Subject *', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _importance,
                items: ['High', 'Moderate', 'Low'].map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                onChanged: (v) => setState(() => _importance = v ?? 'Moderate'),
                decoration: const InputDecoration(labelText: 'Importance', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              // File picker row
              Row(
                children: [
                  SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Pick file'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        foregroundColor: black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _filePath == null ? 'No file selected' : p.basename(_filePath!),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    foregroundColor: black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                      : Text(isEdit ? 'Update Note' : 'Upload Note', style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
