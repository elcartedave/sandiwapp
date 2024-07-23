import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/committeeAnnouncementItem.dart';
import 'package:sandiwapp/components/showDialogs.dart';
import 'package:sandiwapp/models/announcementModel.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/announcement_provider.dart';
import 'package:sandiwapp/screens/execs/CreateAnnouncementPage.dart';

class CommitteeAnnouncement extends StatefulWidget {
  final MyUser user;
  const CommitteeAnnouncement({required this.user, super.key});

  @override
  State<CommitteeAnnouncement> createState() => _CommitteeAnnouncementState();
}

class _CommitteeAnnouncementState extends State<CommitteeAnnouncement> {
  late String type;
  late Stream<QuerySnapshot> announcementsStream;
  @override
  Widget build(BuildContext context) {
    switch (widget.user.lupon) {
      case "Lupon ng Edukasyon at Pananaliksik":
        announcementsStream =
            context.watch<AnnouncementProvider>().edukAnnouncements;
        type = "Eduk";
        break;
      case "Lupon ng Pamamahayag at Publikasyon":
        announcementsStream =
            context.watch<AnnouncementProvider>().pubAnnouncements;
        type = "Pub";
        break;
      case "Lupon ng Kasapian":
        announcementsStream =
            context.watch<AnnouncementProvider>().memAnnouncements;
        type = "Mem";
        break;
      case "Lupon ng Pananalapi":
        announcementsStream =
            context.watch<AnnouncementProvider>().finAnnouncements;
        type = "Fin";
        break;
      case "Lupon ng Ugnayang Panlabas":
        announcementsStream =
            context.watch<AnnouncementProvider>().exteAnnouncements;
        type = "Exte";
        break;
    }

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
          child: StreamBuilder<QuerySnapshot>(
            stream: announcementsStream,
            builder: (context, announcementSnapshot) {
              if (announcementSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              }
              if (announcementSnapshot.hasError) {
                return Center(
                    child: Text("Error: ${announcementSnapshot.error}"));
              }
              if (!announcementSnapshot.hasData ||
                  announcementSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Walang Anunsyo"));
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
                      if (widget.user.position!.contains("Pinuno")) {
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
          )),
      floatingActionButton: widget.user.position!.contains("Pinuno")
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
