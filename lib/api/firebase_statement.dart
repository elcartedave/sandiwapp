import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';

class FirebaseStatementAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final firebaseService = FirebaseAuthAPI();

  Stream<QuerySnapshot> getAllFinalStatement() {
    return db
        .collection('statements')
        .where('isFinal', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getMyDraftStatement() {
    String senderId = firebaseService.getUserId()!;
    return db
        .collection('statements')
        .where('senderId', isEqualTo: senderId)
        .where('isFinal', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getMyFinalStatement() {
    String senderId = firebaseService.getUserId()!;
    return db
        .collection('statements')
        .where('senderId', isEqualTo: senderId)
        .where('isFinal', isEqualTo: true)
        .snapshots();
  }

  Future<String> createStatement(String title, String content) async {
    try {
      String senderId = firebaseService.getUserId()!;
      DocumentReference docRef = db.collection("statements").doc();
      await docRef.set({
        'id': docRef.id,
        'title': title,
        'content': content,
        'date': Timestamp.fromDate(DateTime.now()),
        'senderId': senderId,
        'isFinal': false,
        'status': "Pending"
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deleteStatement(String id) async {
    try {
      await db.collection('statements').doc(id).delete();
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> createAndSubmitStatement(String title, String content) async {
    try {
      String senderId = firebaseService.getUserId()!;
      DocumentReference docRef = db.collection("statements").doc();
      await docRef.set({
        'id': docRef.id,
        'title': title,
        'content': content,
        'date': Timestamp.fromDate(DateTime.now()),
        'senderId': senderId,
        'isFinal': true,
        'status': "Pending"
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> toggleStatus(String id, bool status) async {
    try {
      await db
          .collection('statements')
          .doc(id)
          .update({'status': status ? "Accepted" : "Rejected"});
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> editStatement(String id, String title, String content) async {
    try {
      await db.collection('statements').doc(id).update({
        'title': title,
        'content': content,
        'date': Timestamp.fromDate(DateTime.now())
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> submit(String id, bool isFinal) async {
    try {
      await db.collection('statements').doc(id).update({'isFinal': isFinal});
      return '';
    } catch (e) {
      return e.toString();
    }
  }
}
