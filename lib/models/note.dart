// lib/models/note.dart
class NoteModel {
  int? id;
  String title;
  String semester;
  String subject;
  String filePath; // local path to the uploaded file
  String importance; // High, Moderate, Low
  int teacherId;
  String teacherName;
  int timestamp;

  NoteModel({
    this.id,
    required this.title,
    required this.semester,
    required this.subject,
    required this.filePath,
    required this.importance,
    required this.teacherId,
    required this.teacherName,
    required this.timestamp,
  });

  factory NoteModel.fromMap(Map<String, dynamic> m) => NoteModel(
    id: m['id'],
    title: m['title'],
    semester: m['semester'],
    subject: m['subject'],
    filePath: m['filePath'],
    importance: m['importance'],
    teacherId: m['teacherId'],
    teacherName: m['teacherName'],
    timestamp: m['timestamp'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'semester': semester,
      'subject': subject,
      'filePath': filePath,
      'importance': importance,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'timestamp': timestamp,
    };
  }

  NoteModel copyWith({
    int? id,
    String? title,
    String? semester,
    String? subject,
    String? filePath,
    String? importance,
    int? teacherId,
    String? teacherName,
    int? timestamp,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      semester: semester ?? this.semester,
      subject: subject ?? this.subject,
      filePath: filePath ?? this.filePath,
      importance: importance ?? this.importance,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
