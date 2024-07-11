import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/messageItem.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/messageModel.dart';
import 'package:sandiwapp/providers/message_provider.dart';
import 'package:sandiwapp/screens/applicants/ApplicantMessageItem.dart';

class ApplicantMessages extends StatefulWidget {
  final String userEmail;
  const ApplicantMessages({required this.userEmail, super.key});

  @override
  State<ApplicantMessages> createState() => _ApplicantMessagesState();
}

class _ApplicantMessagesState extends State<ApplicantMessages> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _messagesStream =
        context.watch<MessageProvider>().getUserMessages(widget.userEmail);
    return Scaffold(
      appBar: AppBar(
        title: PatrickHandSC(text: "Mga Mensahe", fontSize: 32),
        scrolledUnderElevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            opacity: 0.4,
            image: AssetImage("assets/images/whitebg3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: StreamBuilder(
            stream: _messagesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Error fetching user data"));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("Messages are empty"));
              }
              var messages = snapshot.data!.docs.map((doc) {
                return Message.fromJson(doc.data() as Map<String, dynamic>);
              }).toList();
              messages.sort((a, b) => b.date.compareTo(a.date));

              return Scrollbar(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool? doesContain =
                        messages[index].sender.contains("Notification");
                    return ApplicantMessageItem(
                      message: messages[index],
                      doesContain: doesContain,
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
