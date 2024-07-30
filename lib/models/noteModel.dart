import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  String text;
  DateTime? date;
  String? userId;
  String content;

  Note({
    this.id,
    required this.text,
    this.date,
    this.userId,
    required this.content,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      text: map['text'],
      date: (map['date'] as Timestamp).toDate(),
      userId: map['userId'],
      content: map['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'id': id,
      'text': text,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'userId': userId,
    };
  }
}
