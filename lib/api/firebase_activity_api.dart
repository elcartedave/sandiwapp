import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/models/activityModel.dart';

class FirebaseActivityAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthAPI _firebaseAuthAPI = FirebaseAuthAPI();
  Future<String> createActivity(Activity activity) async {
    try {
      DocumentReference docRef = _firestore.collection("activities").doc();
      String email = _firebaseAuthAPI.getUserEmail()!;
      // Set the document data with the auto-generated ID
      await docRef.set({
        'id': docRef.id,
        'title': activity.title,
        'content': activity.content,
        'lupon': activity.lupon,
        'sender': email,
        'date': Timestamp.fromDate(activity.date),
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deletePastActivities() async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfToday = DateTime(now.year, now.month, now.day);
      QuerySnapshot querySnapshot = await _firestore
          .collection("activities")
          .where('date', isLessThan: Timestamp.fromDate(startOfToday))
          .get();
      // Loop through the documents and delete each one
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print("Past activities deleted!");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> deleteActivities(String id) async {
    try {
      await _firestore.collection("activities").doc(id).delete();
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  Stream<QuerySnapshot> getActivities(String lupon) {
    return _firestore
        .collection('activities')
        .where('lupon', isEqualTo: lupon)
        .snapshots();
  }

  Stream<QuerySnapshot> getApplicantActivities() {
    String email = _firebaseAuthAPI.getUserEmail()!;
    return _firestore
        .collection('activities')
        .where('lupon', isEqualTo: 'Aplikante')
        .where('sender', isEqualTo: email)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllActivities() {
    return _firestore
        .collection('activities')
        .where('lupon', isEqualTo: 'General')
        .snapshots();
  }
}
