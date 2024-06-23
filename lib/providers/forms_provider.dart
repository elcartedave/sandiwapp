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
}
