import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<String?> signUp(
      String name,
      String nickname,
      String birthday,
      String age,
      String contactno,
      String collegeAddress,
      String homeAddress,
      String email,
      String password) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'nickname': nickname,
        'birthday': birthday,
        'age': age,
        'contactno': contactno,
        'collegeAddress': collegeAddress,
        'homeAddress': homeAddress,
        'email': email,
        'confirmed': false
      });
      return "Sign up success! Wait for the admin approval";
    } on FirebaseAuthException catch (e) {
      return "${e.code}";
    }
  }
}
