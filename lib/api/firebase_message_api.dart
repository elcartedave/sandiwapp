import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/api/firebase_user_api.dart';

class FirebaseMessageApi {
  final FirebaseAuthAPI firebaseAuthAPI = FirebaseAuthAPI();
  final FirebaseUserAPI firebaseUserAPI = FirebaseUserAPI();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUserMessages(String email) {
    return _firestore
        .collection('messages')
        .where('receiver', isEqualTo: email)
        .snapshots();
  }

  Future<String?> createMessage(
      String id, String content, selectedLupon) async {
    try {
      String receiver =
          await firebaseUserAPI.getEmailOfLuponHead(selectedLupon);
      print("RECEIVER: $receiver");
      String sender = await firebaseUserAPI.getNameFromID(id);
      await _firestore.collection('messages').doc().set({
        'content': content,
        'date': Timestamp.fromDate(DateTime.now()),
        'receiver': receiver,
        'sender': sender,
      });
      return "";
    } catch (e) {
      return ("${e.toString()}");
    }
  }
}
