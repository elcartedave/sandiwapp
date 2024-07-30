import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/noteModel.dart';
import 'package:sandiwapp/providers/note_data.dart';
import 'EditingNotePage.dart';

class PersonalNotes extends StatefulWidget {
  final String userId;
  const PersonalNotes({required this.userId, super.key});

  @override
  State<PersonalNotes> createState() => _PersonalNotesState();
}

class _PersonalNotesState extends State<PersonalNotes> {
  void createNewNote() {
    Note newNote = Note(
      text: '',
      date: DateTime.now(),
      userId: widget.userId,
      content: '',
    );
    goToNotePage(newNote, true);
  }

  void goToNotePage(Note note, bool isNewNote) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditingNotePage(
          userId: widget.userId,
          note: note,
          isNewNote: isNewNote,
        ),
      ),
    );
  }

  void deleteNoteWithConfirmation(String id) {
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
                Provider.of<NoteData>(context, listen: false).deleteNote(id);
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
    Stream<QuerySnapshot> _notesStream =
        context.watch<NoteData>().initializeNotes();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: PatrickHandSC(text: "My Personal Notes", fontSize: 32),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Expanded(
              child: CupertinoScrollbar(
                  child: StreamBuilder(
                      stream: _notesStream,
                      builder: (context, value) {
                        if (value.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.black,
                          ));
                        }
                        if (value.hasError) {
                          return const Center(
                              child: Text("Error fetching user data"));
                        }
                        if (!value.hasData || !value.data!.docs.isNotEmpty) {
                          return const Center(
                            child: PatrickHand(text: "No Notes!", fontSize: 20),
                          );
                        }
                        var notes = value.data!.docs.map((doc) {
                          return Note.fromMap(
                              doc.data() as Map<String, dynamic>);
                        }).toList();
                        notes.sort((a, b) => b.date!.compareTo(a.date!));
                        return ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
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
                                    deleteNoteWithConfirmation(note.id!),
                                child: Icon(CupertinoIcons.delete,
                                    color: CupertinoColors.systemRed),
                              ),
                              onTap: () => goToNotePage(note, false),
                            );
                          },
                        );
                      })),
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
