import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyTask {
  final String? id;
  final String recipient;
  final DateTime date;
  final DateTime dueDate;
  bool status;
  final String task;
  MyTask({
    this.id,
    required this.recipient,
    required this.date,
    required this.status,
    required this.dueDate,
    required this.task,
  });

  factory MyTask.fromJson(Map<String, dynamic> json) {
    return MyTask(
      id: json['id'],
      recipient: json['recipient'],
      date: (json['date'] as Timestamp).toDate(),
      status: json['status'],
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      task: json['task'],
    );
  }
  static List<MyTask> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<MyTask>((dynamic d) => MyTask.fromJson(d)).toList();
  }
}
