import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_task_api.dart';

class TaskProvider with ChangeNotifier {
  FirebaseTaskAPI firebaseService = FirebaseTaskAPI();
  Stream<QuerySnapshot> getUserTask() {
    return firebaseService.getUserTask();
  }

  Future<void> toggleTask(String id, bool taskDone) async {
    await firebaseService.toggleTask(id, taskDone);
    notifyListeners();
  }
}
