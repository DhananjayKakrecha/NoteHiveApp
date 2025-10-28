// lib/screens/student_note.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/note.dart';

class StudentNoteScreen extends StatelessWidget {
  final NoteModel note;

  const StudentNoteScreen({Key? key, required this.note}) : super(key: key);

  // Function to download the note
  Future<void> downloadNote(BuildContext context) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission is required to download')),
        );
        return;
      }

      // Get external storage directory for Android, documents for iOS
      Directory dir;
      if (Platform.isAndroid) {
        dir = (await getExternalStorageDirectory())!;
        // Optional: create a "NoteHive" folder
        dir = Directory('${dir.path}/NoteHive');
        if (!await dir.exists()) await dir.create(recursive: true);
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      // Copy file
      String newPath = '${dir.path}/${note.title}${extensionFromPath(note.filePath)}';
      File srcFile = File(note.filePath);
      await srcFile.copy(newPath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note downloaded to $newPath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading note: $e')),
      );
    }
  }

  // Function to share the note
  Future<void> shareNote() async {
    try {
      await Share.shareXFiles(
        [XFile(note.filePath)],
        text: 'Check out this note: ${note.title}',
      );
    } catch (e) {
      print('Error sharing note: $e');
    }
  }

  // Helper to extract file extension
  String extensionFromPath(String path) {
    return path.contains('.') ? '.${path.split('.').last}' : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        backgroundColor: Color(0xFFF7B72F),
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: shareNote,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => downloadNote(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('Subject: ${note.subject}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              Text('Semester: ${note.semester}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              Text('Importance: ${note.importance}', style: const TextStyle(fontSize: 20, color: Colors.redAccent)),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => downloadNote(context),
                  icon: const Icon(Icons.download),
                  label: const Text('Download Note'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF7B72F), // Yellow button
                    foregroundColor: Colors.black, // Black text/icon
                    minimumSize: const Size(200, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
