import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_payment_api.dart';
import 'package:sandiwapp/components/uploadImage.dart';

class PaymentProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _paymentsStream;
  Stream<QuerySnapshot> get payments => _paymentsStream;
  FirebasePaymentAPI firebaseService = FirebasePaymentAPI();

  PaymentProvider() {
    fetchForms();
  }

  Stream<QuerySnapshot> fetchForms() {
    _paymentsStream = firebaseService.getAllPayments();
    notifyListeners();
    return _paymentsStream;
  }

  Future<void> uploadPayment(File image, String userId, String sender) async {
    String photoURL = await uploadImage(image, 'payments');
    await firebaseService.createPayment(photoURL, userId, sender);
  }

  Future<String?> confirmPayment(
      String id, String amount, String userId) async {
    return firebaseService.confirmPayment(id, amount, userId);
  }
}
