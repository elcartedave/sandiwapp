import 'package:cloud_firestore/cloud_firestore.dart';

class MyForm {
  final String? id;
  final String url;
  final DateTime date;
  final String title;
  MyForm({this.id, required this.url, required this.date, required this.title});

  factory MyForm.fromJson(Map<String, dynamic> json) {
    return MyForm(
      id: json['id'],
      url: json['url'],
      date: (json['date'] as Timestamp).toDate(),
      title: json['title'],
    );
  }
}
