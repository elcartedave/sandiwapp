import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/ChatScreen.dart';

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
              String currentId = await context
                  .read<UserAuthProvider>()
                  .authService
                  .getUserId()!;
              String photoURL = await context
                  .read<UserProvider>()
                  .firebaseService
                  .getPhotoURLFromID(currentId);
              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                          myPhotoUrl: photoURL,
                          receiverName: widget.user.name,
                          receiverEmail: widget.user.email,
                          receiverID: widget.user.id!)));
            },
          ),
        ],
      ),
    );
  }
}
