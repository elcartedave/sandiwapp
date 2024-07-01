import 'package:flutter/material.dart';
import 'package:sandiwapp/components/messageEveryone.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/userModel.dart';

class ShowMessageDialog extends StatefulWidget {
  final String senderEmail;
  final MyUser user;
  const ShowMessageDialog(
      {required this.senderEmail, required this.user, super.key});

  @override
  State<ShowMessageDialog> createState() => _ShowMessageDialogState();
}

class _ShowMessageDialogState extends State<ShowMessageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: PatrickHand(text: widget.user.name, fontSize: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.chat_bubble),
            title: PatrickHand(text: "Message", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => MessageEveryone(
                      sender: widget.senderEmail, name: widget.user.name));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
