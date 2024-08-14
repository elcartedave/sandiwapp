import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/chatBubble.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/providers/message_provider.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String receiverName;
  final String myPhotoUrl;
  ChatPage({
    super.key,
    required this.myPhotoUrl,
    required this.receiverEmail,
    required this.receiverID,
    required this.receiverName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: PatrickHand(text: widget.receiverName, fontSize: 24),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/icons/sandiwa_logo.png", // Your image path
              width: 200,
              height: 200,
              opacity: AlwaysStoppedAnimation(0.3),
            ),
          ),
          Column(
            children: [
              // Display messages
              Expanded(
                child: _buildMessageList(context),
              ),
              _buildUserInput(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    String senderID = context.read<UserAuthProvider>().authService.getUserId()!;
    return StreamBuilder(
        stream: context
            .watch<MessageProvider>()
            .getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return PatrickHandSC(text: "Error!", fontSize: 16);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: PatrickHand(text: "No messages yet", fontSize: 16));
          }
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) =>
                    _buildMessageItem(doc, senderID, widget.myPhotoUrl!))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(
      DocumentSnapshot doc, String senderID, String myPhotoUrlFuture) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == senderID;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      padding: EdgeInsets.all(8),
      alignment: alignment,
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCurrentUser)
            Flexible(
                child: ChatBubble(
                    message: data['message'],
                    date: (data['timestamp'] as Timestamp).toDate(),
                    isCurrentUser: true))
          else
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25,
                backgroundImage: data['senderPhotoUrl'] != null &&
                        data['senderPhotoUrl'] != ""
                    ? CachedNetworkImageProvider(data['senderPhotoUrl'])
                    : null,
                child:
                    _buildAvatarChild(data['senderID'], data['senderPhotoUrl']),
              ),
            ),
          if (isCurrentUser && widget.myPhotoUrl != "")
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25,
                backgroundImage: CachedNetworkImageProvider(widget.myPhotoUrl!),
              ),
            ),
          if (isCurrentUser && widget.myPhotoUrl == "")
            const Icon(
              Icons.account_circle,
              size: 50,
              color: Colors.black,
            ),
          if (!isCurrentUser)
            Flexible(
                child: ChatBubble(
                    message: data['message'],
                    date: (data['timestamp'] as Timestamp).toDate(),
                    isCurrentUser: false)),
        ],
      ),
    );
  }

  Widget _buildAvatarChild(String senderID, String? photoUrl) {
    if (senderID.contains("Notification")) {
      return const Icon(
        Icons.mail_outline,
        size: 50,
        color: Colors.black,
      );
    } else if (photoUrl == null || photoUrl.isEmpty) {
      return const Icon(
        Icons.account_circle,
        size: 50,
        color: Colors.black,
      );
    } else {
      return Container();
    }
  }

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: [
          Expanded(
            child: MyTextField2(
                controller: _messageController,
                obscureText: false,
                focusNode: myFocusNode,
                hintText: "Enter message"),
          ),
          Container(
            decoration:
                BoxDecoration(color: Colors.black, shape: BoxShape.circle),
            margin: EdgeInsets.all(16),
            child: IconButton(
                onPressed: () async {
                  if (_messageController.text.isNotEmpty) {
                    String message = await context
                        .read<MessageProvider>()
                        .sendMessage(
                            widget.receiverID, _messageController.text);
                    if (message != "") {
                      showCustomSnackBar(context, message, 85);
                    } else {
                      _messageController.clear();
                    }
                  } else {
                    showCustomSnackBar(
                        context, "Please enter a valid message", 85);
                  }
                  scrollDown();
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}
