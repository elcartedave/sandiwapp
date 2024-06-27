import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/api/firebase_message_api.dart';
import 'package:sandiwapp/api/firebase_user_api.dart';

class FirebaseTaskAPI {
  static final FirebaseAuthAPI auth = FirebaseAuthAPI();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessageApi _firebaseMessageApi = FirebaseMessageApi();
  final FirebaseUserAPI firebaseUserAPI = FirebaseUserAPI();

  Stream<QuerySnapshot> getUserTask() {
    print("current logged in email: ${auth.getUserEmail()}");
    return _firestore
        .collection('tasks')
        .where('recipient', isEqualTo: auth.getUserEmail())
        .snapshots();
  }

  Stream<QuerySnapshot> getSpecificUserTask(String email) {
    return _firestore
        .collection('tasks')
        .where('recipient', isEqualTo: email)
        .snapshots();
  }

  Future<void> toggleTask(String taskId, bool status) async {
    try {
      print("task id: ${taskId}");
      await _firestore.collection('tasks').doc(taskId).update({
        'status': status,
      });
    } catch (e) {
      print('Error updating task status: $e');
    }
  }

  Future<String> createTask(
      String recipientEmail, DateTime dueDate, String task) async {
    try {
      DocumentReference docRef = _firestore.collection("tasks").doc();
      String receiverId = await firebaseUserAPI.getIDFromEmail(recipientEmail);
      // Set the document data with the auto-generated ID
      await docRef.set({
        'id': docRef.id,
        'task': task,
        'recipient': recipientEmail,
        'dueDate': Timestamp.fromDate(dueDate),
        'status': false,
        'date': Timestamp.fromDate(DateTime.now())
      });
      await _firebaseMessageApi.notify(
          receiverId,
          "Mayroon kang bagong task, pumunta lamang sa 'Task Assignments' upang makita ito",
          "Notification");
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deleteTask(String recipient) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("tasks")
          .where('recipient', isEqualTo: recipient)
          .where('status', isEqualTo: true)
          .get(); // Use get() instead of snapshots() for a one-time read

      // Iterate over the documents and delete each one
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      return '';
    } catch (e) {
      return e.toString();
    }
  }
}
