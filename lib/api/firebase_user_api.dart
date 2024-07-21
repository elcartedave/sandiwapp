import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/api/firebase_message_api.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final firebaseService = FirebaseAuthAPI();
  static final FirebaseMessageApi _firebaseMessageApi = FirebaseMessageApi();

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

  Future<String> uploadImage(String photoURL) async {
    try {
      String id = firebaseService.getUserId()!;
      await db.collection('users').doc(id).update({
        'photoUrl': photoURL,
      });
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getIDFromName(String name) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('users')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot.id;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<String> getLuponOfPinuno() async {
    try {
      bool isPinuno = await isCurrentPinuno();
      if (isPinuno) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            await db.collection("users").doc(firebaseService.getUserId()).get();
        if (docSnapshot.exists) {
          Map<String, dynamic>? data = docSnapshot.data();
          if (data != null && data.containsKey('lupon')) {
            print("Position: ${data['position']}");
            if (data['position'] == "Pangkalahatang Kalihim" ||
                data['position'] == "Ikalawang Tagapangulo" ||
                data['position'] == "Tagapangulo") {
              return data['position'] + data['lupon'];
            }
            print(data['lupon']);
            return data['lupon'];
          }
          return '';
        }
        return '';
      }
      return '';
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<String> getIDofHead(String lupon) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('users')
          .where('position', isEqualTo: 'Pinuno ng $lupon')
          .limit(1)
          .get();
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot.id;
    } catch (e) {
      print(e.toString());
      return "";
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

  Future<String> getNameOfLuponHead(String lupon) async {
    try {
      print(lupon);
      QuerySnapshot querySnapshot = await db
          .collection("users")
          .where('position', isEqualTo: lupon)
          .limit(1)
          .get();
      return querySnapshot.docs.first.get('name');
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<String> getEmailFromName(String name) async {
    try {
      print(name);
      QuerySnapshot querySnapshot = await db
          .collection("users")
          .where('name', isEqualTo: name)
          .limit(1)
          .get();
      return querySnapshot.docs.first.get('email');
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<String> getNameFromEmail(String email) async {
    try {
      print(email);
      QuerySnapshot querySnapshot = await db
          .collection("users")
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return querySnapshot.docs.first.get('name');
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<String> getPhotoURLFromEmail(String email) async {
    try {
      print(email);
      QuerySnapshot querySnapshot = await db
          .collection("users")
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return querySnapshot.docs.first.get('photoUrl');
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
        .where("position", isEqualTo: "")
        .snapshots();
  }

  Stream<QuerySnapshot> getApplicants() {
    return db
        .collection('users')
        .where('position', isEqualTo: "Aplikante")
        .snapshots();
  }

  Stream<QuerySnapshot> getFinMembers() {
    return db
        .collection('users')
        .where('position', whereIn: [
          "Residente",
          "Pangkalahatang Kalihim",
          "Ikalawang Tagapangulo",
          "Tagapangulo"
        ])
        .where('lupon', isEqualTo: "Lupon ng Pananalapi")
        .snapshots();
  }

  Stream<QuerySnapshot> getEdukMembers() {
    return db
        .collection('users')
        .where('position', whereIn: [
          "Residente",
          "Pangkalahatang Kalihim",
          "Ikalawang Tagapangulo",
          "Tagapangulo"
        ])
        .where('lupon', isEqualTo: "Lupon ng Edukasyon at Pananaliksik")
        .snapshots();
  }

  Stream<QuerySnapshot> getPubMembers() {
    return db
        .collection('users')
        .where('position', whereIn: [
          "Residente",
          "Pangkalahatang Kalihim",
          "Ikalawang Tagapangulo",
          "Tagapangulo"
        ])
        .where('lupon', isEqualTo: "Lupon ng Pamamahayag at Publikasyon")
        .snapshots();
  }

  Stream<QuerySnapshot> getMemMembers() {
    return db
        .collection('users')
        .where('position', whereIn: [
          "Residente",
          "Pangkalahatang Kalihim",
          "Ikalawang Tagapangulo",
          "Tagapangulo"
        ])
        .where('lupon', isEqualTo: "Lupon ng Kasapian")
        .snapshots();
  }

  Stream<QuerySnapshot> getExteMembers() {
    return db
        .collection('users')
        .where('position', whereIn: [
          "Residente",
          "Pangkalahatang Kalihim",
          "Ikalawang Tagapangulo",
          "Tagapangulo"
        ])
        .where('lupon', isEqualTo: "Lupon ng Ugnayang Panlabas")
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

  Future<String> updateBalance(String id, String newBalance) async {
    try {
      await db.collection('users').doc(id).update({'balance': newBalance});
      await db.collection("users").doc(id).update({'acknowledged': false});
      await _firebaseMessageApi.notify(
          id,
          "Ikaw ay may bagong balanse na Php $newBalance. Paki-acknowledge na lamang ang iyong bagong balanse at pumunta sa 'Bayaran' section upang masettle ito.",
          "Lupon ng Pananalapi");
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateMerit(String id, String merit, String amount) async {
    try {
      if (merit == "Merit") {
        await db.collection('users').doc(id).update({'merit': amount});
        await _firebaseMessageApi.notify(
            id, "Ang iyong merit ay naupdate", "Notification");
      } else {
        await db.collection('users').doc(id).update({'demerit': amount});
        await _firebaseMessageApi.notify(
            id, "Ang iyong demerit ay naupdate", "Notification");
      }
      return '';
    } catch (e) {
      return e.toString();
    }
  }
}
