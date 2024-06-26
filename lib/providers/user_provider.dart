import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_user_api.dart';
import 'package:sandiwapp/models/userModel.dart';

class UserProvider with ChangeNotifier {
  FirebaseUserAPI firebaseService = FirebaseUserAPI();

  late Stream<QuerySnapshot> _usersStream;
  late Stream<QuerySnapshot> _pendingUsersStream;
  late Stream<QuerySnapshot> _applicantsStream;
  late MyUser _currentUser;

  Stream<QuerySnapshot> get users => _usersStream;
  Stream<QuerySnapshot> get pendingUsers => _pendingUsersStream;
  Stream<QuerySnapshot> get applicants => _applicantsStream;
  MyUser get currentUser => _currentUser;

  UserProvider() {
    fetchUsers();
    fetchPendingUsers();
    fetchApplicants();
  }

  Stream<DocumentSnapshot> fetchSpecificUser(String id) {
    return firebaseService.getSpecificUser(id);
  }

  Stream<DocumentSnapshot> fetchCurrentUser() {
    return firebaseService.getCurrentUser();
  }

  Stream<QuerySnapshot> fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
    return _usersStream;
  }

  Future<String> getLuponOfPinuno() async {
    return firebaseService.getLuponOfPinuno();
  }

  Future<void> acceptAndAddLupon(String email, String lupon) async {
    firebaseService.acceptAndAddLupon(email, lupon);
  }

  Future<void> rejectAndDelete(String email) async {
    firebaseService.rejectAndDelete(email);
  }

  Stream<QuerySnapshot> fetchPendingUsers() {
    _pendingUsersStream = firebaseService.getPendingUsers();
    notifyListeners();
    return _pendingUsersStream;
  }

  Stream<QuerySnapshot> fetchApplicants() {
    _applicantsStream = firebaseService.getApplicants();
    notifyListeners();
    return _applicantsStream;
  }

  Future<bool> isCurrentPinuno() async {
    bool isCurrentPinuno = await firebaseService.isCurrentPinuno();
    return isCurrentPinuno;
  }

  Future<bool> isAdmin() async {
    bool isAdmin = await firebaseService.isAdmin();
    return isAdmin;
  }

  Future<bool> isLuponHead() async {
    bool isLuponHead = await firebaseService.isLuponHead();
    return isLuponHead;
  }

  Future<void> toggleAcknowledged(String email, bool acknowledged) async {
    await firebaseService.toggleAcknowledged(email, acknowledged);
    notifyListeners();
  }
}
