import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/providers/link_provider.dart';
import 'package:validator_regex/validator_regex.dart';

class CreatePubLink extends StatefulWidget {
  const CreatePubLink({super.key});

  @override
  State<CreatePubLink> createState() => _CreatePubLinkState();
}

class _CreatePubLinkState extends State<CreatePubLink> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: PatrickHand(text: "Create Pub Link", fontSize: 24),
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const PatrickHand(
                    text: "Enter publication title (or category)",
                    fontSize: 16),
              ),
              MyTextField2(
                  controller: _titleController,
                  obscureText: false,
                  hintText: ''),
              const SizedBox(height: 10),
              Container(
                  alignment: Alignment.topLeft,
                  child: const PatrickHand(
                      text: "Enter the url (should start with https://)",
                      fontSize: 16)),
              MyTextField2(
                  controller: _urlController,
                  obscureText: false,
                  isURL: true,
                  hintText: '')
            ],
          )),
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
                      text: "Add",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          String message = await context
                              .read<LinkProvider>()
                              .createPubLink(
                                  _titleController.text, _urlController.text);
                          if (message == "") {
                            showCustomSnackBar(
                                context, "Link Successfully Added!", 85);

                            Navigator.of(context).pop();
                          } else {
                            showCustomSnackBar(context, message, 85);
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
