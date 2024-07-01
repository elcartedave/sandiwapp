import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_statement.dart';

class StatementProvider with ChangeNotifier {
  FirebaseStatementAPI firebaseService = FirebaseStatementAPI();
  late Stream<QuerySnapshot> _finalStatementStream;
  late Stream<QuerySnapshot> _myFinalStatementStream;
  late Stream<QuerySnapshot> _draftStatementStream;

  Stream<QuerySnapshot> get finalStatements => _finalStatementStream;
  Stream<QuerySnapshot> get myFinalStatements => _myFinalStatementStream;
  Stream<QuerySnapshot> get draftStatements => _draftStatementStream;

  StatementProvider() {
    fetchAllFinalStatements();
    fetchDraftStatements();
    fetchMyFinalStatements();
  }

  Stream<QuerySnapshot> fetchAllFinalStatements() {
    _finalStatementStream = firebaseService.getAllFinalStatement();
    notifyListeners();
    return _finalStatementStream;
  }

  Stream<QuerySnapshot> fetchMyFinalStatements() {
    _myFinalStatementStream = firebaseService.getMyFinalStatement();
    notifyListeners();
    return _myFinalStatementStream;
  }

  Stream<QuerySnapshot> fetchDraftStatements() {
    _draftStatementStream = firebaseService.getMyDraftStatement();
    notifyListeners();
    return _draftStatementStream;
  }

  Future<String> createStatement(String title, String content) {
    return firebaseService.createStatement(title, content);
  }

  Future<String> editStatement(String id, String title, String content) {
    return firebaseService.editStatement(id, title, content);
  }

  Future<String> deleteStatement(String id) {
    return firebaseService.deleteStatement(id);
  }

  Future<String> createAndSubmitStatement(String title, String content) {
    return firebaseService.createAndSubmitStatement(title, content);
  }

  Future<String> submit(String id, bool isFinal) {
    return firebaseService.submit(id, isFinal);
  }

  Future<String> toggleStatus(String id, bool status) {
    return firebaseService.toggleStatus(id, status);
  }
}
