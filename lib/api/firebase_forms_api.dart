import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/api/firebase_user_api.dart';

class FirebaseFormssAPI {
  final FirebaseAuthAPI firebaseAuthAPI = FirebaseAuthAPI();
  final FirebaseUserAPI firebaseUserAPI = FirebaseUserAPI();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllForms() {
    return _firestore.collection('forms').snapshots();
  }

  Future<String> createForms(String title, DateTime dueDate, String url) async {
    try {
      DocumentReference docRef = _firestore.collection("forms").doc();
      await docRef.set({
        'id': docRef.id,
        'title': title,
        'url': url,
        'date': Timestamp.fromDate(dueDate)
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> editForms(
      String title, DateTime dueDate, String url, String id) async {
    try {
      await _firestore.collection('forms').doc(id).update({
        'title': title,
        'url': url,
        'date': Timestamp.fromDate(dueDate),
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deleteForms(String id) async {
    try {
      await _firestore.collection("forms").doc(id).delete();
      return '';
    } catch (e) {
      return e.toString();
    }
  }
}
