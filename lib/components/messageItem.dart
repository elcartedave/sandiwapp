import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/messageEveryone.dart';
import 'package:sandiwapp/models/messageModel.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final bool? doesContain;

  const MessageItem({this.doesContain, required this.message, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("doesContain:$doesContain");
    return InkWell(
      onTap: () {
        if (doesContain == false) {
          showDialog(
              context: context,
              builder: (context) {
                return MessageEveryone(
                    name: message.sender, sender: message.receiver);
              });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.mail_outline, size: 40),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.sender,
                          style: GoogleFonts.patrickHand(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          shortDateFormatter(message.date),
                          style: GoogleFonts.patrickHand(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    message.content,
                    style: GoogleFonts.patrickHand(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
