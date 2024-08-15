import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/providers/message_provider.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/screens/ChatScreen.dart';

class ChatRoomsPage extends StatefulWidget {
  final String myPhotoUrl;
  const ChatRoomsPage({super.key, required this.myPhotoUrl});

  @override
  State<ChatRoomsPage> createState() => _ChatRoomsPageState();
}

class _ChatRoomsPageState extends State<ChatRoomsPage> {
  @override
  Widget build(BuildContext context) {
    final String currentUserID =
        context.read<UserAuthProvider>().authService.getUserId()!;
    Stream<QuerySnapshot> _chatRoomsStream =
        context.watch<MessageProvider>().chatRooms;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Mga Mensahe"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatRoomsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          }

          final chatRooms = snapshot.data!.docs.where((doc) {
            return doc.id.contains(currentUserID);
          }).toList();

          if (chatRooms.isEmpty) {
            return Center(child: Text("No messages yet!"));
          }

          return StreamBuilder<List<Map<String, dynamic>>>(
            stream:
                Stream.fromFuture(Future.wait(chatRooms.map((chatRoom) async {
              final chatRoomID = chatRoom.id;
              final timestamp = await fetchMostRecentTimestamp(chatRoomID);
              return {
                'chatRoom': chatRoom,
                'timestamp': timestamp,
              };
            }).toList())),
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              }

              final chatRoomsWithTimestamps = asyncSnapshot.data!;

              // Sort the chat rooms by the most recent timestamp
              chatRoomsWithTimestamps.sort((a, b) {
                final timestampA = a['timestamp'] as Timestamp?;
                final timestampB = b['timestamp'] as Timestamp?;
                return timestampB!.compareTo(timestampA!);
              });

              return ListView.builder(
                itemCount: chatRoomsWithTimestamps.length,
                itemBuilder: (context, index) {
                  final chatRoom = chatRoomsWithTimestamps[index]['chatRoom']
                      as DocumentSnapshot;
                  final timestamp =
                      chatRoomsWithTimestamps[index]['timestamp'] as Timestamp?;

                  final String chatRoomID = chatRoom.id;

                  final String receiverID = chatRoomID
                      .split('_')
                      .firstWhere((id) => id != currentUserID);

                  if (chatRoomID.contains("Notification")) {
                    // Handle "Notification" chat rooms differently
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chat_rooms")
                          .doc(chatRoomID)
                          .collection("messages")
                          .orderBy("timestamp", descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, messageSnapshot) {
                        if (!messageSnapshot.hasData) {
                          return Container();
                        }

                        final mostRecentMessage =
                            messageSnapshot.data!.docs.first;
                        final String messageText =
                            mostRecentMessage['message'] ?? "No message";
                        final DateTime messageDate =
                            mostRecentMessage['timestamp'].toDate();

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Icon(
                              Icons.notifications,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            "Notification",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: messageText,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  shortDateFormatter(messageDate),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    myPhotoUrl: widget.myPhotoUrl,
                                    receiverEmail: "",
                                    receiverID: receiverID,
                                    receiverName: "Notification",
                                    isNotification: true),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  // Original user chat room handling
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("chat_rooms")
                        .doc(chatRoomID)
                        .collection("messages")
                        .orderBy("timestamp", descending: true)
                        .limit(1)
                        .snapshots(),
                    builder: (context, messageSnapshot) {
                      if (!messageSnapshot.hasData) {
                        return Container();
                      }

                      final mostRecentMessage =
                          messageSnapshot.data!.docs.first;
                      final String messageText =
                          mostRecentMessage['message'] ?? "No message";
                      final DateTime messageDate =
                          mostRecentMessage['timestamp'].toDate();
                      final String senderID = mostRecentMessage['senderID'];

                      // Determine if the message is sent by the current user
                      final isSentByMe = senderID == currentUserID;

                      return FutureBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(receiverID)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) {
                            return Container();
                          }

                          final user = userSnapshot.data!;
                          final String receiverName = user['name'];
                          final String receiverEmail = user['email'];
                          final String receiverPhotoURL =
                              user['photoUrl'] ?? "";

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              backgroundImage: receiverPhotoURL.isNotEmpty
                                  ? CachedNetworkImageProvider(receiverPhotoURL,
                                      scale: 6)
                                  : null,
                              child: receiverPhotoURL.isEmpty
                                  ? Icon(
                                      Icons.account_circle,
                                      color: Colors.black,
                                      size: 60,
                                    )
                                  : null,
                            ),
                            title: Text(
                              receiverName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        if (isSentByMe)
                                          TextSpan(
                                            text: "Me: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        TextSpan(
                                          text: messageText,
                                          style: TextStyle(
                                            fontWeight: isSentByMe
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    shortDateFormatter(messageDate),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    myPhotoUrl: widget.myPhotoUrl,
                                    receiverEmail: receiverEmail,
                                    receiverID: receiverID,
                                    receiverName: receiverName,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<Timestamp?> fetchMostRecentTimestamp(String chatRoomID) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.get('timestamp');
    } else {
      return null;
    }
  }
}
