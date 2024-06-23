import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';

class FirebaseTaskAPI {
  static final FirebaseAuthAPI auth = FirebaseAuthAPI();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUserTask() {
    return _firestore
        .collection('tasks')
        .where('recipient', isEqualTo: auth.getUserEmail())
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
}
