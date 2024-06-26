import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/showDialogs.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/announcementModel.dart';
import 'package:sandiwapp/providers/announcement_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/execs/CreateAnnouncementPage.dart';
import 'package:sandiwapp/screens/users/organization/announcements/OrgAnnouncementPage.dart';

class OrgAnnouncement extends StatefulWidget {
  const OrgAnnouncement({super.key});

  @override
  State<OrgAnnouncement> createState() => _OrgAnnouncementState();
}

class _OrgAnnouncementState extends State<OrgAnnouncement> {
  late bool pinuno = false;
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> announcementsStream =
        context.read<AnnouncementProvider>().genAnnouncements;
    Future<bool> isCurrentPinuno =
        context.read<UserProvider>().isCurrentPinuno();
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 0, 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: PatrickHand(text: "Mga Anunsiyo", fontSize: 33)),
              const SizedBox(width: 5),
              FutureBuilder(
                  future: isCurrentPinuno,
                  builder: (context, pinunoSnapshot) {
                    if (pinunoSnapshot.data == true) {
                      pinuno = pinunoSnapshot.data!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateAnnouncementPage(
                                        type: "General",
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            radius: Radius.circular(16),
                            strokeWidth: 2,
                            dashPattern: [8, 2],
                            borderPadding: EdgeInsets.all(2),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                                Text(
                                  "Magdagdag",
                                  style: blackText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  })
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: announcementsStream,
              builder: (context, announcementSnapshot) {
                if (announcementSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: Colors.black));
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
                    final announcement = announcements[index];
                    return InkWell(
                      splashColor: const Color.fromARGB(0, 255, 255, 255),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrgAnnouncementPage(
                                announcement: announcement, isPinuno: pinuno),
                          ),
                        );
                      },
                      onLongPress: () {
                        if (pinuno) {
                          showDialog(
                              context: context,
                              builder: (context) => ShowAnnouncementDialog(
                                  announcement: announcement));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.campaign, size: 65),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    announcement.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.patrickHand(
                                      height: 1,
                                      fontSize: 23,
                                    ),
                                  ),
                                  PatrickHand(
                                    text: dateFormatter(announcement.date),
                                    fontSize: 12,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    announcement.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
