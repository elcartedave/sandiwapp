import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_message_api.dart';

class MessageProvider with ChangeNotifier {
  FirebaseMessageApi _firebaseMessageApi = FirebaseMessageApi();

  Stream<QuerySnapshot> getUserMessages(String email) {
    return _firebaseMessageApi.getUserMessages(email);
  }

  Future<String?> sendMessage(
      String id, String content, String selectedLupon, String photoUrl) async {
    return _firebaseMessageApi.createMessage(
        id, content, selectedLupon, photoUrl);
  }

  Future<String?> messageEveryone(
      String senderEmail, String content, String name) async {
    return _firebaseMessageApi.messageEveryone(senderEmail, content, name);
  }

  Future<void> deleteOldMessages() async {
    await _firebaseMessageApi.deleteOldMessages();
  }
}
