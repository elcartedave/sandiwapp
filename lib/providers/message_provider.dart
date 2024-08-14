import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_message_api.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseMessageApi _firebaseMessageApi = FirebaseMessageApi();

  late Stream<QuerySnapshot> _chatRooms;
  Stream<QuerySnapshot> get chatRooms => _chatRooms;

  MessageProvider() {
    fetchChatRooms();
  }

  Stream<QuerySnapshot> fetchChatRooms() {
    _chatRooms = _firebaseMessageApi.getChatRooms();
    notifyListeners();
    return _chatRooms;
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    return _firebaseMessageApi.getMessages(userID, otherUserID);
  }

  Future<String> sendMessage(
    String receiverID,
    String message,
  ) async {
    return _firebaseMessageApi.sendMessage(receiverID, message);
  }
}
