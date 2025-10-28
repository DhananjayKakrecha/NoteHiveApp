// lib/providers/note_provider.dart
import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  final DBHelper _db = DBHelper();
  List<NoteModel> _notes = [];

  List<NoteModel> get notes => _notes;

  Future<void> loadAll() async {
    _notes = await _db.getAllNotes();
    notifyListeners();
  }

  Future<void> loadByTeacher(int teacherId) async {
    _notes = await _db.getNotesByTeacher(teacherId);
    notifyListeners();
  }

  Future<void> addNote(NoteModel n, {int? teacherId}) async {
    await _db.insertNote(n);
    if (teacherId != null) {
      await loadByTeacher(teacherId);
    } else {
      await loadAll();
    }
  }

  Future<void> updateNote(NoteModel n, {int? teacherId}) async {
    await _db.updateNote(n);
    if (teacherId != null) {
      await loadByTeacher(teacherId);
    } else {
      await loadAll();
    }
  }

  Future<void> deleteNote(int id, {int? teacherId}) async {
    await _db.deleteNote(id);
    if (teacherId != null) {
      await loadByTeacher(teacherId);
    } else {
      await loadAll();
    }
  }

  Future<List<NoteModel>> search(String q) async {
    return await _db.searchNotes(q);
  }

  Future<List<NoteModel>> filter({String? importance, String? semester}) async {
    return await _db.filterNotes(importance: importance, semester: semester);
  }
}
