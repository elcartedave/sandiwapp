import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/noteModel.dart';
import 'package:sandiwapp/providers/note_data.dart';
import 'EditingNotePage.dart';

class PersonalNotes extends StatefulWidget {
  const PersonalNotes({super.key});

  @override
  State<PersonalNotes> createState() => _PersonalNotesState();
}

class _PersonalNotesState extends State<PersonalNotes> {
  void createNewNote() {
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;
    Note newNote = Note(
      id: id,
      text: '',
      date: DateTime.now(),
    );
    goToNotePage(newNote, true);
  }

  void goToNotePage(Note note, bool isNewNote) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditingNotePage(
          note: note,
          isNewNote: isNewNote,
        ),
      ),
    );
  }

  void deleteNoteWithConfirmation(Note note) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Provider.of<NoteData>(context, listen: false).deleteNote(note);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: PatrickHandSC(text: "My Personal Notes", fontSize: 32),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Notes are stored in the device and is not stored on the account!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: value.getAllNotes().isEmpty
                        ? Center(
                            child: PatrickHand(text: "No Notes!", fontSize: 20),
                          )
                        : CupertinoScrollbar(
                            child: ListView.builder(
                              itemCount: value.getAllNotes().length,
                              itemBuilder: (context, index) {
                                final note = value.getAllNotes()[index];
                                return CupertinoListTile(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  leading: Text(
                                    shortDateFormatter(note.date!),
                                    style: TextStyle(
                                        color: CupertinoColors.systemGrey,
                                        fontSize: 14),
                                  ),
                                  title: Text(
                                    note.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () =>
                                        deleteNoteWithConfirmation(note),
                                    child: Icon(CupertinoIcons.delete,
                                        color: CupertinoColors.systemRed),
                                  ),
                                  onTap: () => goToNotePage(note, false),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: CupertinoButton(
                  onPressed: createNewNote,
                  color: CupertinoColors.black,
                  padding: EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(
                    CupertinoIcons.add,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CupertinoListTile extends StatelessWidget {
  final EdgeInsets? padding;
  final Widget leading;
  final Widget title;
  final Widget trailing;
  final VoidCallback onTap;

  const CupertinoListTile({
    Key? key,
    this.padding,
    required this.leading,
    required this.title,
    required this.trailing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: CupertinoColors.systemGrey4, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            leading,
            SizedBox(width: 10),
            Expanded(child: title),
            trailing,
          ],
        ),
      ),
    );
  }
}
