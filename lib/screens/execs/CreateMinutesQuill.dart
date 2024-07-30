import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/linksModel.dart';
import 'package:sandiwapp/providers/link_provider.dart';

class CreateMinutesQuill extends StatefulWidget {
  final Link? minutes;
  final bool isNewMinutes;
  const CreateMinutesQuill(
      {required this.isNewMinutes, this.minutes, super.key});

  @override
  State<CreateMinutesQuill> createState() => _CreateMinutesQuillState();
}

class _CreateMinutesQuillState extends State<CreateMinutesQuill> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late TextEditingController _titleController;
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.minutes == null ? '' : widget.minutes!.title);
    if (widget.minutes != null) {
      loadExistingMinutes();
    }
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
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: PatrickHand(
            text: "${widget.isNewMinutes ? "Create" : "Edit"} Minutes",
            fontSize: 20),
        scrolledUnderElevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        PatrickHandSC(
                            text: "Title/Designation (ex. Minutes of GA)",
                            fontSize: 20),
                        MyTextField2(
                            controller: _titleController,
                            obscureText: false,
                            hintText: ""),
                        const SizedBox(height: 10),
                        PatrickHandSC(text: "Content", fontSize: 20),
                        Container(
                          height: 550,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(
                                12), // Adjust the radius as needed
                          ),
                          child: Column(
                            children: [
                              QuillToolbar.simple(
                                configurations:
                                    QuillSimpleToolbarConfigurations(
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
                                  controller: _controller,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(25),
                                  child: Scrollbar(
                                    child: QuillEditor.basic(
                                      configurations: QuillEditorConfigurations(
                                          controller: _controller),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                      child: BlackButton(
                        text: "SAVE",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            late String message;
                            setState(() {
                              _isLoading = true;
                            });
                            if (widget.isNewMinutes) {
                              message = await context
                                  .read<LinkProvider>()
                                  .createMinutesQuill(
                                      _titleController.text,
                                      _controller.document.toPlainText(),
                                      jsonEncode(_controller.document
                                          .toDelta()
                                          .toJson()));
                            } else {
                              message = await context
                                  .read<LinkProvider>()
                                  .editMinutesQuill(
                                      widget.minutes!.id!,
                                      _titleController.text,
                                      _controller.document.toPlainText(),
                                      jsonEncode(_controller.document
                                          .toDelta()
                                          .toJson()));
                            }
                            if (message == '') {
                              showCustomSnackBar(
                                  context,
                                  "Minutes successfully ${widget.isNewMinutes ? "added" : "edited"}!",
                                  120);
                              Navigator.pop(context);
                            } else {
                              showCustomSnackBar(context, message, 120);
                            }
                          }
                        },
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 16),
                child: MyTextButton(
                  text: "DISCARD CHANGES",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
