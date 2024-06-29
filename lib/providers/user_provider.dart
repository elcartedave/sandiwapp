import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_user_api.dart';
import 'package:sandiwapp/components/uploadImage.dart';
import 'package:sandiwapp/models/userModel.dart';

class UserProvider with ChangeNotifier {
  FirebaseUserAPI firebaseService = FirebaseUserAPI();

  late Stream<QuerySnapshot> _usersStream;
  late Stream<QuerySnapshot> _pendingUsersStream;
  late Stream<QuerySnapshot> _applicantsStream;
  late Stream<QuerySnapshot> _eduksStream;
  late Stream<QuerySnapshot> _finsStream;
  late Stream<QuerySnapshot> _pubsStream;
  late Stream<QuerySnapshot> _extesStream;
  late Stream<QuerySnapshot> _memsStream;
  late MyUser _currentUser;

  Stream<QuerySnapshot> get users => _usersStream;
  Stream<QuerySnapshot> get pendingUsers => _pendingUsersStream;
  Stream<QuerySnapshot> get applicants => _applicantsStream;
  Stream<QuerySnapshot> get eduks => _eduksStream;
  Stream<QuerySnapshot> get fins => _finsStream;
  Stream<QuerySnapshot> get pubs => _pubsStream;
  Stream<QuerySnapshot> get extes => _extesStream;
  Stream<QuerySnapshot> get mems => _memsStream;
  MyUser get currentUser => _currentUser;

  UserProvider() {
    fetchUsers();
    fetchPendingUsers();
    fetchApplicants();
    fetchEduks();
    fetchFins();
    fetchPubs();
    fetchMems();
    fetchExtes();
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

  Future<String> addPhoto(File image, String photoUrl) async {
    String photoURL = photoUrl;
    if (photoURL != "") {
      await deleteFileFromUrl(photoURL);
    }
    photoURL = await uploadImage(image, 'residents');
    return firebaseService.uploadImage(photoURL);
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

  Stream<QuerySnapshot> fetchEduks() {
    _eduksStream = firebaseService.getEdukMembers();
    notifyListeners();
    return _eduksStream;
  }

  Stream<QuerySnapshot> fetchFins() {
    _finsStream = firebaseService.getFinMembers();
    notifyListeners();
    return _finsStream;
  }

  Stream<QuerySnapshot> fetchPubs() {
    _pubsStream = firebaseService.getPubMembers();
    notifyListeners();
    return _pubsStream;
  }

  Stream<QuerySnapshot> fetchExtes() {
    _extesStream = firebaseService.getExteMembers();
    notifyListeners();
    return _extesStream;
  }

  Stream<QuerySnapshot> fetchMems() {
    _memsStream = firebaseService.getMemMembers();
    notifyListeners();
    return _memsStream;
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

  Future<String> updateBalance(String id, String newAmount) async {
    return firebaseService.updateBalance(id, newAmount);
  }
}
