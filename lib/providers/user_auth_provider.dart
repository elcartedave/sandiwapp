import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> _uStream;
  User? get user => authService.getUser();
  Stream<User?> get userStream => _uStream;
  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
    fetchUsers();
  }
  void fetchAuthentication() {
    //checks if there is changes in authstate
    _uStream = authService.userSignedIn();
    notifyListeners(); // Added listener to notify listeners on auth state changes
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }

  Stream<QuerySnapshot> fetchUsers() {
    return authService.getAllUsers(); //gets the list of all todos available
  }
}
