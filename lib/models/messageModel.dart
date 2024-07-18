import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id;
  final String sender;
  final String content;
  final String receiver;
  final DateTime date;
  final String? photoUrl;

  Message({
    this.id,
    required this.receiver,
    required this.date,
    required this.sender,
    required this.content,
    this.photoUrl,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      receiver: json['receiver'],
      date: (json['date'] as Timestamp).toDate(),
      sender: json['sender'],
      content: json['content'],
      photoUrl: json['photoUrl'],
    );
  }
  static List<Message> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Message>((dynamic d) => Message.fromJson(d)).toList();
  }
}
