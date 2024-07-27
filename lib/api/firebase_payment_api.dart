import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/api/firebase_message_api.dart';
import 'package:sandiwapp/api/firebase_user_api.dart';

class FirebasePaymentAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessageApi _firebaseMessageApi = FirebaseMessageApi();
  final FirebaseAuthAPI firebaseAuthAPI = FirebaseAuthAPI();
  final FirebaseUserAPI firebaseUserAPI = FirebaseUserAPI();

  Stream<QuerySnapshot> getAllPayments() {
    return _firestore.collection('payments').snapshots();
  }

  Future<void> createPayment(
      String photoURL, String userId, String sender) async {
    DocumentReference docRef = _firestore.collection("payments").doc();
    String receiver = await firebaseUserAPI.getIDofHead("Lupon ng Pananalapi");
    try {
      await docRef.set({
        'date': Timestamp.fromDate(DateTime.now()),
        'confirmed': false,
        'id': docRef.id,
        'photoURL': photoURL,
        'userId': userId,
        'sender': sender,
        'amount': ''
      });
      await _firebaseMessageApi.notify(
          receiver,
          "Si $sender ay nagpadala ng payment, pumunta lamang sa 'View Payments' upang makita ito",
          "Notification");
      await _firebaseMessageApi.notify(
          firebaseAuthAPI.getUserId()!,
          "Ang iyong payment ay naipadala na, pakihintay na lamang ang kumpirmasyon ng Lupon ng Pananalapi",
          "Notification");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getBalance(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();
      return querySnapshot.docs.first.get('balance');
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  Future<String?> confirmPayment(
      String id, String amount, String userId) async {
    String balance = await getBalance(userId);
    String name = await firebaseUserAPI.getNameFromID(userId);
    print("name: $name");
    try {
      if (balance != "") {
        await _firestore
            .collection('payments')
            .doc(id)
            .update({'confirmed': true, 'amount': amount});
        String newBalance =
            (double.parse(balance) - double.parse(amount)).toStringAsFixed(2);
        await _firestore
            .collection("users")
            .doc(userId)
            .update({'balance': newBalance});
        await _firestore
            .collection("users")
            .doc(userId)
            .update({'acknowledged': false});
        if (newBalance == "0" || newBalance == "0.0") {
          await _firestore
              .collection("users")
              .doc(userId)
              .update({'paid': true});
        }
        await _firebaseMessageApi.notify(
            userId,
            "Ang iyong payment na nagkakahalagang Php ${amount} ay nakumpirma. ${newBalance == "0" || newBalance == "0.0" ? "Wala ka nang natitirang balanse!" : "Ikaw ay may balanse pang Php ${newBalance}"}. Paki-acknowledge na lamang ang iyong bagong balanse.",
            "Lupon ng Pananalapi");

        await _firebaseMessageApi.notify(
            firebaseAuthAPI.getUserId()!,
            "Ang payment ni $name na Php ${amount} ay nakumpirma. ${newBalance == "0" || newBalance == "0.0" ? "Wala na siyang balanse" : "Siya ay may balanse pang Php ${newBalance}"}",
            "Notification");
        return "";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
