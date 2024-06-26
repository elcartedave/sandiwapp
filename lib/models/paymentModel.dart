import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String? id;
  final String? amount;
  final DateTime? date;
  final bool? confirmed;
  final String? sender;
  final String photoURL;
  final String userId;

  Payment(
      {this.date,
      this.amount,
      this.confirmed,
      this.sender,
      this.id,
      required this.photoURL,
      required this.userId});
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
        date: (json['date'] as Timestamp).toDate(),
        amount: json['amount'],
        confirmed: json['confirmed'],
        id: json['id'],
        photoURL: json['photoURL'],
        userId: json['userId'],
        sender: json['sender']);
  }
}
