import 'package:hive_flutter/hive_flutter.dart';
import '../models/noteModel.dart';

class HiveDatabase {
  final _myBox = Hive.box('note_database');

  List<Note> loadNotes() {
    List<Note> savedNotesFormatted = [];
    var savedNotes = _myBox.get("ALL_NOTES", defaultValue: []);
    for (var noteMap in savedNotes) {
      Note individualNote = Note.fromMap(noteMap);
      savedNotesFormatted.add(individualNote);
    }
    return savedNotesFormatted;
  }

  void saveNotes(List<Note> allNotes) {
    List<Map<String, dynamic>> allNotesFormatted =
        allNotes.map((note) => note.toMap()).toList();
    _myBox.put("ALL_NOTES", allNotesFormatted);
  }
}
