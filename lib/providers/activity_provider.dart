import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_activity_api.dart';
import 'package:sandiwapp/models/activityModel.dart';

class ActivityProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _activitiesStream;
  Stream<QuerySnapshot> get activities => _activitiesStream;

  late Stream<QuerySnapshot> _allActivitiesStream;
  Stream<QuerySnapshot> get allActivities => _allActivitiesStream;
  FirebaseActivityAPI firebaseService = FirebaseActivityAPI();

  ActivityProvider() {
    fetchAllActivities();
    fetchApplicantActivities();
    deletePastActivities();
  }
  Stream<QuerySnapshot> fetchActivities(String lupon) {
    deletePastActivities();
    return firebaseService.getActivities(lupon);
  }

  Stream<QuerySnapshot> fetchApplicantActivities() {
    deletePastActivities();
    return firebaseService.getApplicantActivities();
  }

  Stream<QuerySnapshot> fetchAllActivities() {
    _allActivitiesStream = firebaseService.getAllActivities();
    notifyListeners();
    return _allActivitiesStream;
  }

  Future<String> createActivity(Activity activity) async {
    return firebaseService.createActivity(activity);
  }

  Future<String> createAppActivity(Activity activity) async {
    return firebaseService.createAppActivity(activity);
  }

  Future<void> deletePastActivities() async {
    await firebaseService.deletePastActivities();
  }

  Future<String> deleteActivities(String id) async {
    return firebaseService.deleteActivities(id);
  }
}
