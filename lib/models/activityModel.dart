import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String title;
  final String content;
  final DateTime date;
  final String lupon;
  final String? id;
  Activity(
      {required this.title,
      required this.content,
      required this.date,
      required this.lupon,
      this.id});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      title: json['title'],
      date: (json['date'] as Timestamp).toDate(),
      content: json['content'],
      lupon: json['lupon'],
    );
  }
}
