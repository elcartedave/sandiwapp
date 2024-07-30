import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/models/noteModel.dart';

class FirebaseNoteApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthAPI firebaseAuthAPI = FirebaseAuthAPI();
  static final FirebaseAuthAPI auth = FirebaseAuthAPI();
  Stream<QuerySnapshot> getUserNote() {
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: auth.getUserId())
        .snapshots();
  }

  Future<String> addNewNote(Note note) async {
    try {
      DocumentReference docRef = _firestore.collection('notes').doc();
      note.userId = auth.getUserId();
      note.id = docRef.id;
      await docRef.set(note.toMap());
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateNote(Note note, String text, String content) async {
    try {
      note.text = text;
      note.content = content;
      note.date = DateTime.now();
      await _firestore
          .collection('notes')
          .doc(note.id.toString())
          .update(note.toMap());
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deleteNote(String id) async {
    try {
      await _firestore.collection('notes').doc(id).delete();
      return '';
    } catch (e) {
      return e.toString();
    }
  }
}
