import 'package:cloud_firestore/cloud_firestore.dart';

class Link {
  final String? id;
  final String title;
  final String? caption;
  final String category;
  final String url;
  final DateTime date;
  final String? format;
  Link(
      {required this.title,
      this.caption,
      this.id,
      required this.category,
      required this.url,
      this.format,
      required this.date});
  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      caption: json['caption'],
      url: json['url'],
      format: json['format'],
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}
