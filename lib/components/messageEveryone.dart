import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/providers/message_provider.dart';

class MessageEveryone extends StatefulWidget {
  final String? name;
  final String? sender;
  const MessageEveryone({required this.sender, required this.name, super.key});

  @override
  State<MessageEveryone> createState() => _MessageEveryoneState();
}

class _MessageEveryoneState extends State<MessageEveryone> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Magpadala ng Mensahe:",
        style: GoogleFonts.patrickHand(color: Colors.black, fontSize: 30),
        textAlign: TextAlign.left,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Magmensahe kay:",
                style: blackText,
              ),
              Text(
                widget.name!,
                style: blackText,
              ),
              const SizedBox(height: 10),
              Text("MESSAGE:", style: blackText),
              MyTextField2(
                controller: _messageController,
                obscureText: false,
                hintText: "Magpadala ng mensahe",
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
      actions: [
        _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : BlackButton(
                text: "Ipadala",
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    String? result = await context
                        .read<MessageProvider>()
                        .messageEveryone(widget.sender!,
                            _messageController.text, widget.name!);
                    if (result == null || result == "") {
                      showCustomSnackBar(context, "Message sent!", 100);
                    } else {
                      showCustomSnackBar(context, result, 100);
                    }
                    Navigator.of(context).pop();
                  }
                },
              ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: MyTextButton(
              text: "Bumalik",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        )
      ],
    );
  }
}
