import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final firebaseService = FirebaseAuthAPI();

  Stream<QuerySnapshot> getAllUsers() {
    // obtain a stream of all users
    return db
        .collection("users")
        .where("confirmed", isEqualTo: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getSpecificUser(String id) {
    // obtain a stream of specific user document
    return db.collection("users").doc(id).snapshots();
  }

  Future<String> getEmailFromID(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await db.collection("users").doc(id).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if (data != null && data.containsKey('email')) {
          return data['email'] as String;
        }
      }
      return '';
    } catch (e) {
      print('Error fetching email: $e');
      return '';
    }
  }

  Future<String> getIDFromEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot.id;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<String> getNameFromID(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await db.collection("users").doc(id).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if (data != null && data.containsKey('name')) {
          return data['name'] as String;
        }
      }
      return '';
    } catch (e) {
      print('Error fetching name: $e');
      return '';
    }
  }

  Future<bool> isCurrentPinuno() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await db.collection("users").doc(firebaseService.getUserId()).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if (data != null && data.containsKey('position')) {
          return data['position'] != "Residente" &&
              data['position'] != "Aplikante";
        }
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> isLuponHead() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await db.collection("users").doc(firebaseService.getUserId()).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if (data != null && data.containsKey('position')) {
          return data['position'] != "Residente" &&
              data['position'] != "Ikalawang Tagapangulo" &&
              data['position'] != "Tagapangulo" &&
              data['position'] != "Pangkalahatang Kalihim";
        }
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> isAdmin() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await db.collection("admin").doc(firebaseService.getUserId()).get();
      if (docSnapshot.exists) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String> getEmailOfLuponHead(String lupon) async {
    try {
      print(lupon);
      QuerySnapshot querySnapshot = await db
          .collection("users")
          .where('position', isEqualTo: lupon)
          .limit(1)
          .get();
      return querySnapshot.docs.first.get('email');
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<void> acceptAndAddLupon(String email, String lupon) async {
    final querySnapshot = await db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      final userDocRef = docSnapshot.reference;

      String position = '';
      if (lupon.contains('Resi-')) {
        lupon = lupon.replaceAll('Resi-', '');
        position = 'Residente';
      } else if (lupon.contains('Head-')) {
        lupon = lupon.replaceAll('Head-', '');
        position = "Pinuno ng $lupon";
      } else if (lupon.contains('Aplikante')) {
        position = lupon;
      } else if (lupon.contains('Sec-')) {
        lupon = lupon.replaceAll('Sec-', '');
        position = "Pangkalahatang Kalihim";
      } else if (lupon.contains('VP-')) {
        lupon = lupon.replaceAll('VP-', '');
        position = "Ikalawang Tagapangulo";
      } else if (lupon.contains('Pres-')) {
        lupon = lupon.replaceAll('Pres-', '');
        position = "Tagapangulo";
      }

      await userDocRef.update({
        'confirmed': true,
        'position': position,
        'lupon': lupon,
      });
    } else {
      print('No user found with email $email');
    }
  }

  Future<void> rejectAndDelete(String email) async {
    String id = await getIDFromEmail(email);
    await db.collection("users").doc(id).delete();
  }

  Stream<QuerySnapshot> getPendingUsers() {
    // obtain a stream of pending users
    return db
        .collection("users")
        .where("confirmed", isEqualTo: false)
        .snapshots();
  }

  Stream<DocumentSnapshot> getCurrentUser() {
    // obtain a stream of the currently logged in user
    print("firebase user id: ${firebaseService.getUserId()!}");
    return db.collection("users").doc(firebaseService.getUserId()!).snapshots();
  }

  Future<String> toggleAcknowledged(String email, bool value) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      await querySnapshot.docs.first.reference.update({"acknowledged": value});
      return "Successfully toggled!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }
}
