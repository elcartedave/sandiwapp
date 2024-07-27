import 'package:flutter/foundation.dart';
import '../hive_database/hive_database.dart';
import '../models/noteModel.dart';

class NoteData extends ChangeNotifier {
  final db = HiveDatabase();
  List<Note> allNotes = [];

  NoteData() {
    initializeNotes();
  }

  void initializeNotes() {
    allNotes = db.loadNotes();
    notifyListeners();
  }

  List<Note> getAllNotes() {
    return allNotes;
  }

  void addNewNote(Note note) {
    allNotes.add(note);
    sortNotesByDate();
    db.saveNotes(allNotes);
    notifyListeners();
  }

  void updateNote(Note note, String text) {
    for (var n in allNotes) {
      if (n.id == note.id) {
        n.text = text;
        n.date = DateTime.now();
        break;
      }
    }
    db.saveNotes(allNotes);
    notifyListeners();
  }

  void deleteNote(Note note) {
    allNotes.remove(note);
    db.saveNotes(allNotes);
    notifyListeners();
  }

  void sortNotesByDate() {
    allNotes.sort((a, b) => b.date!.compareTo(a.date!));
  }
}
