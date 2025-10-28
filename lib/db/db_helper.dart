// lib/db/db_helper.dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "notehive.db");

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT UNIQUE,
      password TEXT,
      role TEXT
    );
    ''');
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      semester TEXT,
      subject TEXT,
      filePath TEXT,
      importance TEXT,
      teacherId INTEGER,
      teacherName TEXT,
      timestamp INTEGER
    );
    ''');

    // Insert default admin (username/password)
    await db.insert('users', {
      'name': 'Super Admin',
      'email': 'admin@notehive.com',
      'password': 'admin123', // for demo - change in production
      'role': UserRole.admin
    });
  }

  // users
  Future<int> insertUser(UserModel u) async {
    final d = await db;
    return await d.insert('users', u.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final d = await db;
    final res = await d.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isNotEmpty) return UserModel.fromMap(res.first);
    return null;
  }

  Future<List<UserModel>> getTeachers() async {
    final d = await db;
    final res = await d.query('users', where: 'role = ?', whereArgs: [UserRole.teacher]);
    return res.map((m) => UserModel.fromMap(m)).toList();
  }

  // notes
  Future<int> insertNote(NoteModel n) async {
    final d = await db;
    return await d.insert('notes', n.toMap());
  }

  Future<int> updateNote(NoteModel n) async {
    final d = await db;
    return await d.update('notes', n.toMap(), where: 'id = ?', whereArgs: [n.id]);
  }

  Future<int> deleteNote(int id) async {
    final d = await db;
    return await d.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<NoteModel>> getAllNotes() async {
    final d = await db;
    final res = await d.query('notes', orderBy: 'timestamp DESC');
    return res.map((m) => NoteModel.fromMap(m)).toList();
  }

  Future<List<NoteModel>> getNotesByTeacher(int teacherId) async {
    final d = await db;
    final res = await d.query('notes', where: 'teacherId = ?', whereArgs: [teacherId], orderBy: 'timestamp DESC');
    return res.map((m) => NoteModel.fromMap(m)).toList();
  }

  Future<List<NoteModel>> searchNotes(String query) async {
    final d = await db;
    final q = '%$query%';
    final res = await d.rawQuery('''
      SELECT * FROM notes WHERE subject LIKE ? OR title LIKE ? OR teacherName LIKE ? ORDER BY timestamp DESC
    ''', [q, q, q]);
    return res.map((m) => NoteModel.fromMap(m)).toList();
  }

  Future<List<NoteModel>> filterNotes({String? importance, String? semester}) async {
    final d = await db;
    String where = '';
    List args = [];
    if (importance != null) {
      where += 'importance = ?';
      args.add(importance);
    }
    if (semester != null) {
      if (where.isNotEmpty) where += ' AND ';
      where += 'semester = ?';
      args.add(semester);
    }
    final res = await d.query('notes', where: where.isEmpty ? null : where, whereArgs: args, orderBy: 'timestamp DESC');
    return res.map((m) => NoteModel.fromMap(m)).toList();
  }
}
