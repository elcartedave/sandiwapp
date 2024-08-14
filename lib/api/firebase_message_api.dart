import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/api/firebase_user_api.dart';
import 'package:sandiwapp/models/messageModel.dart';

class FirebaseMessageApi {
  final FirebaseAuthAPI firebaseAuthAPI = FirebaseAuthAPI();
  final FirebaseUserAPI firebaseUserAPI = FirebaseUserAPI();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRooms() {
    return _firestore.collection("chat_rooms").snapshots();
  }

  Future<String> sendMessage(String receiverID, message,
      {String? senderID, String? senderEmail, String? senderPhotoUrl}) async {
    //get current user info
    try {
      final String currentUserID = senderID ?? firebaseAuthAPI.getUserId()!;
      final String currentUserEmail =
          senderEmail ?? firebaseAuthAPI.getUserEmail()!;
      final String currentSenderPhotoUrl = senderPhotoUrl ??
          await firebaseUserAPI.getPhotoURLFromID(currentUserID);
      final String receiverPhotoUrl =
          await firebaseUserAPI.getPhotoURLFromID(receiverID);
      final Timestamp timestamp = Timestamp.now();
      List<String> ids = [currentUserID, receiverID];
      ids.sort(); //any 2 people have same id;
      String chatRoomID = ids.join('_');
      //create new message
      Message newMessage = Message(
          senderID: currentUserID,
          receiverID: receiverID,
          senderEmail: currentUserEmail,
          message: message,
          senderPhotoUrl: currentSenderPhotoUrl,
          receiverPhotoUrl: receiverPhotoUrl,
          id: chatRoomID,
          timestamp: timestamp);
      //construct chat room id

      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add(newMessage.toMap());
      await _firestore.collection("chat_rooms").doc(chatRoomID).set({
        "chatRoomID": chatRoomID,
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> notify(String receiverId, String message) async {
    try {
      await sendMessage(
        receiverId,
        message,
        senderID: "1234Notification1234",
        senderEmail: "1234Notification1234",
        senderPhotoUrl: "Notification",
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
