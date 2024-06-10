import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> _uStream;
  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }
  void fetchAuthentication() {
    //checks if there is changes in authstate
    _uStream = authService.userSignedIn();
    notifyListeners(); // Added listener to notify listeners on auth state changes
  }
}
