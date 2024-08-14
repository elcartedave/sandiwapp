import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id;
  final String senderID;
  final String senderEmail;
  final String message;
  final String receiverID;
  final Timestamp timestamp;
  final String? senderPhotoUrl;
  final String? receiverPhotoUrl;

  Message({
    this.id,
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timestamp,
    this.senderPhotoUrl,
    this.receiverPhotoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
      'senderPhotoUrl': senderPhotoUrl,
      'receiverPhotoUrl': receiverPhotoUrl,
    };
  }
}
