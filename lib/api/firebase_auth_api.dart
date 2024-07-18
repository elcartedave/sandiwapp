import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/models/userModel.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> userSignedIn() {
    return auth.authStateChanges();
  }

  User? getUser() {
    //returns the current user
    return auth.currentUser;
  }

  String? getUserEmail() {
    //returns the current user email
    print("User email: ${auth.currentUser!.email}");
    return auth.currentUser!.email;
  }

  Stream<QuerySnapshot> getAllUsers() {
    //gets all todo instances of a specific user
    return _firestore.collection("users").snapshots();
  }

  Future<bool> isUserAdmin(String email) async {
    // checks if user is an admin
    try {
      QuerySnapshot adminSnapshot = await _firestore
          .collection('admin')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return adminSnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> userStatus(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var docData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return docData['confirmed'];
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isApplicant(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('position', isEqualTo: 'Aplikante')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<String?> signUp(MyUser user) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'id': credential.user!.uid,
        'name': user.name,
        'nickname': user.nickname,
        'birthday': user.birthday,
        'age': user.age,
        'contactno': user.contactno,
        'collegeAddress': user.collegeAddress,
        'homeAddress': user.homeAddress,
        'email': user.email,
        'sponsor': user.sponsor,
        'batch': user.batch,
        'lupon': user.lupon,
        'confirmed': user.confirmed,
        'balance': user.balance,
        'paid': user.paid,
        'merit': user.merit,
        'demerit': user.demerit,
        'position': user.position,
        'photoUrl': user.photoUrl,
        'acknowledged': user.acknowledged,
        'paymentProofUrl': user.paymentProofUrl,
        'degprog': user.degprog,
      });
      return "";
    } on FirebaseAuthException catch (e) {
      return "${e.code}";
    }
  }

  Future<void> signOut() async {
    //sign out
    await auth.signOut();
  }

  String? getUserId() {
    return auth.currentUser!.uid;
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "";
    } on FirebaseAuthException catch (e) {
      return (e.code == "invalid-credential"
          ? "Incorrect email or password"
          : e.code);
    } catch (e) {
      return "Sign in error";
    }
  }
}
