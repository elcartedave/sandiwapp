import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/committeeAnnouncementItem.dart';
import 'package:sandiwapp/components/showDialogs.dart';
import 'package:sandiwapp/models/announcementModel.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/announcement_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/execs/CreateAnnouncementPage.dart';

class CommitteeAnnouncement extends StatefulWidget {
  final bool isLuponHead;
  const CommitteeAnnouncement({required this.isLuponHead, super.key});

  @override
  State<CommitteeAnnouncement> createState() => _CommitteeAnnouncementState();
}

class _CommitteeAnnouncementState extends State<CommitteeAnnouncement> {
  late String type;
  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _userStream =
        context.watch<UserProvider>().fetchCurrentUser();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "Mga Anunsyo Sa Aking Lupon",
          style: GoogleFonts.patrickHand(fontSize: 24),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _userStream,
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (userSnapshot.hasError) {
              return Center(child: Text("Error: ${userSnapshot.error}"));
            }
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return Center(child: Text("User data not found"));
            }

            MyUser user = MyUser.fromJson(
                userSnapshot.data!.data() as Map<String, dynamic>);
            late Stream<QuerySnapshot> announcementsStream;

            switch (user.lupon) {
              case "Lupon ng Edukasyon at Pananaliksik":
                announcementsStream =
                    context.read<AnnouncementProvider>().edukAnnouncements;
                type = "Eduk";
                break;
              case "Lupon ng Pamamahayag at Publikasyon":
                announcementsStream =
                    context.read<AnnouncementProvider>().pubAnnouncements;
                type = "Pub";
                break;
              case "Lupon ng Kasapian":
                announcementsStream =
                    context.read<AnnouncementProvider>().memAnnouncements;
                type = "Mem";
                break;
              case "Lupon ng Pananalapi":
                announcementsStream =
                    context.read<AnnouncementProvider>().finAnnouncements;
                type = "Fin";
                break;
              case "Lupon ng Ugnayang Panlabas":
                announcementsStream =
                    context.read<AnnouncementProvider>().exteAnnouncements;
                type = "Exte";
                break;
            }

            return StreamBuilder<QuerySnapshot>(
              stream: announcementsStream,
              builder: (context, announcementSnapshot) {
                if (announcementSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (announcementSnapshot.hasError) {
                  return Center(
                      child: Text("Error: ${announcementSnapshot.error}"));
                }
                if (!announcementSnapshot.hasData ||
                    announcementSnapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Walang Anunsyo"));
                }

                var announcements = announcementSnapshot.data!.docs.map((doc) {
                  return Announcement.fromJson(
                      doc.data() as Map<String, dynamic>);
                }).toList();

                announcements.sort((a, b) => b.date.compareTo(a.date));

                return ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onLongPress: () {
                        if (widget.isLuponHead) {
                          showDialog(
                              context: context,
                              builder: (context) => ShowAnnouncementDialog(
                                  announcement: announcements[index]));
                        }
                      },
                      child: CommAnnouncementItem(
                          commAnnouncement: announcements[index]),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: widget.isLuponHead
          ? FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateAnnouncementPage(type: type)));
              },
              backgroundColor: Colors.black,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
