import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/models/messageModel.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    Text(
                      message.sender,
                      style: GoogleFonts.patrickHand(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      "${message.date.year.toString()}-${message.date.month.toString().padLeft(2, '0')}-${message.date.day.toString().padLeft(2, '0')} ${message.date.hour.toString().padLeft(2, '0')}:${message.date.minute.toString().padLeft(2, '0')}",
                      style: GoogleFonts.patrickHand(fontSize: 18),
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
    );
  }
}
