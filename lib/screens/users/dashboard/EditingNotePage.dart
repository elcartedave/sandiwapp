import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/models/noteModel.dart';
import 'package:sandiwapp/providers/note_data.dart';

class EditingNotePage extends StatefulWidget {
  final Note note;
  final bool isNewNote;
  final String userId;
  EditingNotePage(
      {required this.userId,
      required this.note,
      required this.isNewNote,
      super.key});

  @override
  State<EditingNotePage> createState() => _EditingNotePageState();
}

class _EditingNotePageState extends State<EditingNotePage> {
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    loadExistingNote();
  }

  void loadExistingNote() {
    final List<dynamic> docJson = widget.note.content.isNotEmpty
        ? jsonDecode(widget.note.content)
        : [
            {"insert": "\n"}
          ];
    final doc = Document.fromJson(docJson);
    setState(() {
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    });
  }

  void addNewNote() {
    String text = _controller.document.toPlainText();
    String content = jsonEncode(_controller.document.toDelta().toJson());
    Provider.of<NoteData>(context, listen: false).addNewNote(Note(
      text: text,
      content: content,
      userId: widget.userId,
      date: DateTime.now(),
    ));
  }

  void updateNote() {
    String text = _controller.document.toPlainText();
    String content = jsonEncode(_controller.document.toDelta().toJson());
    Provider.of<NoteData>(context, listen: false).updateNote(
      widget.note,
      text,
      content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(actions: [
        GestureDetector(
          onTap: () {
            if (widget.isNewNote && !_controller.document.isEmpty()) {
              addNewNote();
              Navigator.pop(context);
            } else if (_controller.document.isEmpty()) {
              showCustomSnackBar(context, "Note is empty!", 30);
            } else {
              updateNote();
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text("SAVE", style: GoogleFonts.patrickHand(fontSize: 20)),
              Icon(Icons.save),
            ]),
          ),
        ),
      ]),
      body: Column(
        children: [
          QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                  showAlignmentButtons: false,
                  showBackgroundColorButton: false,
                  showCenterAlignment: false,
                  showClearFormat: false,
                  showClipboardCopy: false,
                  showClipboardCut: false,
                  showClipboardPaste: false,
                  showCodeBlock: false,
                  showColorButton: false,
                  showDirection: false,
                  showDividers: false,
                  showFontFamily: false,
                  showFontSize: false,
                  showHeaderStyle: false,
                  showIndent: false,
                  showInlineCode: false,
                  showItalicButton: false,
                  showJustifyAlignment: false,
                  showLeftAlignment: false,
                  showLineHeightButton: false,
                  showLink: false,
                  showQuote: false,
                  showRightAlignment: false,
                  showSearchButton: false,
                  showSmallButton: false,
                  showStrikeThrough: false,
                  showSubscript: false,
                  showSuperscript: false,
                  color: Colors.white,
                  controller: _controller)),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(25),
            child: QuillEditor.basic(
              configurations:
                  QuillEditorConfigurations(controller: _controller),
            ),
          ))
        ],
      ),
    );
  }
}
