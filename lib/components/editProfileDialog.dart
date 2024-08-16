import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class EditProfileDialog extends StatefulWidget {
  final String content;
  final String type;
  const EditProfileDialog(
      {required this.content, required this.type, super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String identifyType(String type) {
    switch (type) {
      case "Nickname:":
        return "nickname";
      case "Contact Number:":
        return "contactno";
      case "Degree Program:":
        return "degprog";
      case "College Address:":
        return "collegeAddress";
      case "Home Address:":
        return "homeAddress";
      default:
        return "";
    }
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      scrollable: true,
      title: PatrickHand(
          text: "Edit ${widget.type.replaceAll(':', '')}", fontSize: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
              key: _formKey,
              child: MyTextField2(
                  isNumber: widget.type == "Contact Number:" ? true : null,
                  controller: _textController,
                  obscureText: false,
                  hintText: ""))
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : BlackButton(
                      text: "I-update",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          String message = await context
                              .read<UserProvider>()
                              .editAttribute(identifyType(widget.type),
                                  _textController.text);
                          if (message == "") {
                            showCustomSnackBar(
                                context,
                                "${widget.type.replaceAll(':', '')} Successfully Edited!",
                                120);
                            Navigator.of(context).pop();
                          } else {
                            showCustomSnackBar(context, message, 120);
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Center(
                child: WhiteButton(
                  text: "Bumalik",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
