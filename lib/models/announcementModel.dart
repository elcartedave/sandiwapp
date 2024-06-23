import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String? id;
  final String title;
  final String content;
  final DateTime date;
  final String committee; //general, lupon("eduk", "pub", "mem", "fin", "exte")

  Announcement(
      {this.id,
      required this.date,
      required this.title,
      required this.content,
      required this.committee});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
        id: json['id'],
        date: (json['date'] as Timestamp).toDate(),
        title: json['title'],
        content: json['content'],
        committee: json['committee']);
  }
  static List<Announcement> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<Announcement>((dynamic d) => Announcement.fromJson(d))
        .toList();
  }

  Map<String, dynamic> toJson(Announcement Announcement) {
    return {
      'title': Announcement.title,
      'content': Announcement.content,
      'committee': Announcement.committee,
      'date': Announcement.date
    };
  }
}
