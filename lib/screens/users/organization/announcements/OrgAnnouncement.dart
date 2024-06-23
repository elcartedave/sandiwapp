import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/announcementModel.dart';
import 'package:sandiwapp/providers/announcement_provider.dart';
import 'package:sandiwapp/screens/users/organization/announcements/OrgAnnouncementPage.dart';

class OrgAnnouncement extends StatefulWidget {
  const OrgAnnouncement({super.key});

  @override
  State<OrgAnnouncement> createState() => _OrgAnnouncementState();
}

class _OrgAnnouncementState extends State<OrgAnnouncement> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> announcementsStream =
        context.read<AnnouncementProvider>().genAnnouncements;
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 8),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: PatrickHand(text: "Mga Anunsiyo", fontSize: 33),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
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
                    final announcement = announcements[index];
                    return InkWell(
                      splashColor: const Color.fromARGB(0, 255, 255, 255),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrgAnnouncementPage(
                              announcement: announcement,
                            ),
                          ),
                        );
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
                                    text:
                                        "${announcement.date.year.toString()}-${announcement.date.month.toString().padLeft(2, '0')}-${announcement.date.day.toString().padLeft(2, '0')} ${announcement.date.hour.toString().padLeft(2, '0')}:${announcement.date.minute.toString().padLeft(2, '0')}",
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
