import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/api/firebase_note_api.dart';
import 'package:sandiwapp/models/noteModel.dart';

class NoteData extends ChangeNotifier {
  final FirebaseNoteApi firebaseService = FirebaseNoteApi();
  final FirebaseAuthAPI auth = FirebaseAuthAPI();
  late Stream<QuerySnapshot> _notesStream;
  Stream<QuerySnapshot> get notes => _notesStream;
  NoteData() {
    initializeNotes();
  }

  Stream<QuerySnapshot> initializeNotes() {
    _notesStream = firebaseService.getUserNote();
    notifyListeners();
    return _notesStream;
  }

  Future<String> addNewNote(Note note) async {
    return firebaseService.addNewNote(note);
  }

  Future<String> updateNote(Note note, String text, String content) async {
    return firebaseService.updateNote(note, text, content);
  }

  Future<String> deleteNote(String id) async {
    return firebaseService.deleteNote(id);
  }
}
