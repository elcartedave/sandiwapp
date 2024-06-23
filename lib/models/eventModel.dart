import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  final String title;
  final String place;
  final String fee;
  final String? photoUrl;
  final DateTime date;
  final List<dynamic>? attendees;

  Event(
      {this.id,
      required this.date,
      required this.title,
      required this.place,
      required this.fee,
      required this.photoUrl,
      required this.attendees});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      date: (json['date'] as Timestamp).toDate(),
      title: json['title'],
      place: json['place'],
      fee: json['fee'],
      photoUrl: json['photoUrl'],
      attendees: json['attendees'] ?? [],
    );
  }
  static List<Event> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Event>((dynamic d) => Event.fromJson(d)).toList();
  }
}
