import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sandiwapp/api/firebase_forms_api.dart';

class FormsProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _formsStream;
  Stream<QuerySnapshot> get forms => _formsStream;
  FirebaseFormssAPI firebaseService = FirebaseFormssAPI();

  FormsProvider() {
    fetchForms();
  }

  Stream<QuerySnapshot> fetchForms() {
    _formsStream = firebaseService.getAllForms();
    notifyListeners();
    return _formsStream;
  }

  Future<String> createForms(String title, DateTime dueDate, String url) async {
    return firebaseService.createForms(title, dueDate, url);
  }

  Future<String> editForms(
      String title, DateTime dueDate, String url, String id) async {
    return firebaseService.editForms(title, dueDate, url, id);
  }

  Future<String> deleteForms(String id) {
    return firebaseService.deleteForms(id);
  }
}
