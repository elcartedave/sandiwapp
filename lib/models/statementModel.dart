import 'package:cloud_firestore/cloud_firestore.dart';

class Statement {
  final String title;
  final String content;
  final String? id;
  final String senderId;
  final DateTime date;
  final bool isFinal;
  final String status;
  final String? format;
  Statement(
      {required this.title,
      this.format,
      required this.content,
      required this.senderId,
      required this.date,
      required this.status,
      this.id,
      required this.isFinal});

  factory Statement.fromJson(Map<String, dynamic> json) {
    return Statement(
        id: json['id'],
        status: json['status'],
        title: json['title'],
        content: json['content'],
        senderId: json['senderId'],
        date: (json['date'] as Timestamp).toDate(),
        isFinal: json['isFinal'],
        format: json['format']);
  }
}
