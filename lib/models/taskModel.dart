import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String? id;
  final String recipient;
  final DateTime date;
  final String dueDate;
  bool status;
  final String task;
  Task({
    this.id,
    required this.recipient,
    required this.date,
    required this.status,
    required this.dueDate,
    required this.task,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      recipient: json['recipient'],
      date: (json['date'] as Timestamp).toDate(),
      status: json['status'],
      dueDate: json['dueDate'],
      task: json['task'],
    );
  }
  static List<Task> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Task>((dynamic d) => Task.fromJson(d)).toList();
  }
}
