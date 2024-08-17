import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/linksModel.dart';

class ViewMinutes extends StatefulWidget {
  final Link minutes;
  const ViewMinutes({required this.minutes, super.key});

  @override
  State<ViewMinutes> createState() => _ViewMinutesState();
}

class _ViewMinutesState extends State<ViewMinutes> {
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    loadExistingMinutes();
  }

  void loadExistingMinutes() {
    final List<dynamic> docJson = widget.minutes!.format != null
        ? jsonDecode(widget.minutes!.format!)
        : [
            {"insert": "\n"}
          ];
    final doc = Document.fromJson(docJson);
    setState(() {
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: PatrickHand(text: widget.minutes.title, fontSize: 20),
        scrolledUnderElevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PatrickHandSC(
                    text: dateFormatter(widget.minutes.date), fontSize: 16),
                const SizedBox(height: 10),
                QuillEditor.basic(
                  controller: _controller,
                  configurations: QuillEditorConfigurations(
                    readOnlyMouseCursor: MouseCursor.defer,
                    disableClipboard: true,
                    floatingCursorDisabled: true,
                    checkBoxReadOnly: true,
                    showCursor: false,
                    scrollable: false,
                    isOnTapOutsideEnabled: false,
                    padding: EdgeInsets.zero,
                    autoFocus: false,
                    expands: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
