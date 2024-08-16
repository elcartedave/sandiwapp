import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_task_api.dart';

class TaskProvider with ChangeNotifier {
  FirebaseTaskAPI firebaseService = FirebaseTaskAPI();
  late Stream<QuerySnapshot> _taskStream;
  Stream<QuerySnapshot> get tasks => _taskStream;

  TaskProvider() {
    fetchTasks();
  }

  Stream<QuerySnapshot> fetchTasks() {
    _taskStream = firebaseService.getUserTask();
    notifyListeners();
    return _taskStream;
  }

  Stream<QuerySnapshot> fetchUserTasks(String email) {
    return firebaseService.getSpecificUserTask(email);
  }

  Future<void> toggleTask(String id, bool taskDone) async {
    await firebaseService.toggleTask(id, taskDone);
    notifyListeners();
  }

  Future<String> createTask(
      String recipientEmail, DateTime dueDate, String task) async {
    return firebaseService.createTask(recipientEmail, dueDate, task);
  }

  Future<String> deleteTask(String email) async {
    return firebaseService.deleteTask(email);
  }

  Future<String> editTask(String id, DateTime dueDate, String content) {
    return firebaseService.editTask(id, dueDate, content);
  }

  Future<String> deleteaTask(String id) async {
    return firebaseService.deleteaTask(id);
  }
}
