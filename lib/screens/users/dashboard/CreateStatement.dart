import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/statementModel.dart';
import 'package:sandiwapp/providers/statement_provider.dart';

class CreateStatement extends StatefulWidget {
  final Statement? statement;
  final bool? isPinuno;
  const CreateStatement({this.isPinuno, this.statement, super.key});

  @override
  State<CreateStatement> createState() => _CreateStatementState();
}

class _CreateStatementState extends State<CreateStatement> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoading2 = false;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.statement == null ? '' : widget.statement!.title);
    _contentController = TextEditingController(
        text: widget.statement == null ? '' : widget.statement!.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PatrickHand(
                text:
                    "${widget.statement == null ? "Create" : "Edit"} ${widget.isPinuno != null ? "Statement" : "Draft"}",
                fontSize: 20),
            widget.isPinuno != null
                ? Container()
                : _isLoading2
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          if (_contentController.text != "" &&
                              _titleController.text != "") {
                            setState(() {
                              _isLoading2 = true;
                            });
                            if (widget.statement == null) {
                              String message = await context
                                  .read<StatementProvider>()
                                  .createAndSubmitStatement(
                                      _titleController.text,
                                      _contentController.text);
                              if (message == '') {
                                showCustomSnackBar(
                                    context,
                                    "Statement submitted to head for approval",
                                    30);
                                Navigator.pop(context);
                              } else {
                                showCustomSnackBar(context, message, 120);
                              }
                              setState(() {
                                _isLoading2 = false;
                              });
                            } else {
                              String message = await context
                                  .read<StatementProvider>()
                                  .submit(widget.statement!.id!, true);
                              if (message == "") {
                                showCustomSnackBar(
                                    context,
                                    "Statement submitted to head for approval",
                                    30);
                                Navigator.pop(context);
                              } else {
                                showCustomSnackBar(context, message, 30);
                              }
                              setState(() {
                                _isLoading2 = false;
                              });
                            }
                          } else {
                            showCustomSnackBar(
                                context, "Please fill empty fields", 120);
                          }
                        },
                        child: Text(
                          "Send to Head",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      )
          ],
        ),
        scrolledUnderElevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      PatrickHandSC(
                          text: "Title/Designation (ex. Undas Statement)",
                          fontSize: 20),
                      MyTextField2(
                          controller: _titleController,
                          obscureText: false,
                          hintText: ""),
                      const SizedBox(height: 10),
                      PatrickHandSC(text: "Content", fontSize: 20),
                      MyTextField2(
                        controller: _contentController,
                        obscureText: false,
                        hintText: "",
                        maxLines: 15,
                      ),
                    ],
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
                        text:
                            "SAVE ${widget.isPinuno != null ? "STATEMENT" : "DRAFT"}",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            late String message;
                            setState(() {
                              _isLoading = true;
                            });
                            if (widget.statement == null) {
                              print(true);
                              message = await context
                                  .read<StatementProvider>()
                                  .createStatement(_titleController.text,
                                      _contentController.text);
                            } else {
                              print(false);
                              message = await context
                                  .read<StatementProvider>()
                                  .editStatement(
                                      widget.statement!.id!,
                                      _titleController.text,
                                      _contentController.text);
                            }
                            if (message == '') {
                              showCustomSnackBar(
                                  context,
                                  "${widget.isPinuno != null ? "Statement" : "Draft"} successfully ${widget.statement == null ? "added" : "edited"}!",
                                  30);
                              Navigator.pop(context);
                            } else {
                              showCustomSnackBar(context, message, 30);
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
