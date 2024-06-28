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
  }
  Stream<QuerySnapshot> fetchActivities(String lupon) {
    return firebaseService.getActivities(lupon);
  }

  Stream<QuerySnapshot> fetchAllActivities() {
    _allActivitiesStream = firebaseService.getAllActivities();
    notifyListeners();
    return _allActivitiesStream;
  }

  Future<String> createActivity(Activity activity) async {
    return firebaseService.createActivity(activity);
  }
}
