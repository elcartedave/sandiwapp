import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/messageEveryone.dart';
import 'package:sandiwapp/models/messageModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/models/userModel.dart';

class ApplicantMessageItem extends StatelessWidget {
  final Message message;
  final bool? doesContain;

  const ApplicantMessageItem({
    this.doesContain,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.watch<UserProvider>().fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SizedBox.shrink();
        }
        List<MyUser> users = snapshot.data!.docs.map((doc) {
          return MyUser.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        MyUser? senderUser = users.firstWhere(
          (user) => user.name == message.sender,
        );

        return InkWell(
          onTap: () {
            if (doesContain == false) {
              showDialog(
                context: context,
                builder: (context) {
                  return MessageEveryone(
                      name: message.sender, sender: message.receiver);
                },
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 25,
                      child: senderUser != null && senderUser.photoUrl != ""
                          ? null
                          : const Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Colors.black,
                            ),
                      backgroundImage:
                          senderUser != null && senderUser.photoUrl != ""
                              ? NetworkImage(senderUser.photoUrl!)
                              : null,
                    ),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                shortDateFormatter(message.date),
                                style: GoogleFonts.patrickHand(fontSize: 16),
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
            ),
          ),
        );
      },
    );
  }
}
