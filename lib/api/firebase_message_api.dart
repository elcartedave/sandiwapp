import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/api/firebase_user_api.dart';

class FirebaseMessageApi {
  final FirebaseAuthAPI firebaseAuthAPI = FirebaseAuthAPI();
  final FirebaseUserAPI firebaseUserAPI = FirebaseUserAPI();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUserMessages(String email) {
    deleteOldMessages();
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

  Future<void> deleteOldMessages() async {
    try {
      final DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
      final QuerySnapshot querySnapshot = await _firestore
          .collection('messages')
          .where('date', isLessThan: Timestamp.fromDate(sevenDaysAgo))
          .get();

      WriteBatch batch = _firestore.batch();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      print("Deleted message");
      return batch.commit();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> messageEveryone(
      String senderEmail, String content, String name) async {
    try {
      late String receiver;
      if (name.contains("Lupon ng ")) {
        receiver = await firebaseUserAPI.getEmailOfLuponHead("Pinuno ng $name");
      } else {
        receiver = await firebaseUserAPI.getEmailFromName(name);
      }
      print("RECEIVER: $receiver");
      String sender = await firebaseUserAPI.getNameFromEmail(senderEmail);
      print("sender: $sender");
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

  Future<void> notify(
      String receiverId, String message, String senderName) async {
    try {
      String receiver = await firebaseUserAPI.getEmailFromID(receiverId);
      print("Receiver: ${receiver}");
      await _firestore.collection('messages').doc().set({
        'content': message,
        'date': Timestamp.fromDate(DateTime.now()),
        'receiver': receiver,
        'sender': senderName
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
