import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/messageItem.dart';
import 'package:sandiwapp/models/announcementModel.dart';
import 'package:sandiwapp/models/messageModel.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/message_provider.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class MyMessages extends StatefulWidget {
  const MyMessages({super.key});

  @override
  State<MyMessages> createState() => _MyMessagesState();
}

class _MyMessagesState extends State<MyMessages> {
  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
    _subscribeToMessagesTopic();
  }

  void _requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _subscribeToMessagesTopic() {
    FirebaseMessaging.instance.subscribeToTopic('messages');
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _userStream =
        context.watch<UserProvider>().fetchCurrentUser();

    return StreamBuilder(
        stream: _userStream,
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
          if (!snapshot.hasData || !snapshot.data!.exists) {
            context.read<UserAuthProvider>().signOut();
            return Center(child: Text("User data not available"));
          }
          MyUser user =
              MyUser.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          Stream<QuerySnapshot> messagesStream =
              context.read<MessageProvider>().getUserMessages(user.email);
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 3),
            child: StreamBuilder(
                stream: messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    ));
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Error fetching user data"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("Messages are empty"));
                  }
                  var messages = snapshot.data!.docs.map((doc) {
                    return Message.fromJson(doc.data() as Map<String, dynamic>);
                  }).toList();
                  messages.sort((a, b) => b.date.compareTo(a.date));

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      bool? doesContain =
                          messages[index].sender.contains("Notification");
                      return MessageItem(
                        message: messages[index],
                        doesContain: doesContain,
                      );
                    },
                  );
                }),
          );
        });
  }
}
