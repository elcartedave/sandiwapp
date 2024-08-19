import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/committeeAnnouncementItem.dart';
import 'package:sandiwapp/components/showDialogs.dart';
import 'package:sandiwapp/models/announcementModel.dart';
import 'package:sandiwapp/providers/announcement_provider.dart';
import 'package:sandiwapp/screens/execs/CreateAnnouncementPage.dart';
import 'package:sandiwapp/screens/execs/CreateEventPage.dart';

class ApplicantAnnouncement extends StatefulWidget {
  final bool isPinuno;
  const ApplicantAnnouncement({required this.isPinuno, super.key});

  @override
  State<ApplicantAnnouncement> createState() => _ApplicantAnnouncementState();
}

class _ApplicantAnnouncementState extends State<ApplicantAnnouncement> {
  @override
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _announcementsStream =
        context.watch<AnnouncementProvider>().appAnnouncements;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          "Mga Anunsyo",
          style: GoogleFonts.patrickHandSc(fontSize: 32),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  opacity: 0.5,
                  image: AssetImage("assets/images/sunflower.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (widget.isPinuno)
                  BlackButton(
                    text: "Gumawa ng Event",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CreateEventPage(isApplicant: true),
                        ),
                      );
                    },
                  ),
                Expanded(
                  child: StreamBuilder(
                    stream: _announcementsStream,
                    builder: (context, announcementSnapshot) {
                      if (announcementSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        ));
                      }
                      if (announcementSnapshot.hasError) {
                        return Center(
                            child:
                                Text("Error: ${announcementSnapshot.error}"));
                      }
                      if (!announcementSnapshot.hasData ||
                          announcementSnapshot.data!.docs.isEmpty) {
                        return Center(child: Text("Walang Anunsyo"));
                      }

                      var announcements =
                          announcementSnapshot.data!.docs.map((doc) {
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
                              if (widget.isPinuno) {
                                showDialog(
                                  context: context,
                                  builder: (context) => ShowAnnouncementDialog(
                                    announcement: announcements[index],
                                  ),
                                );
                              }
                            },
                            child: CommAnnouncementItem(
                              isPinuno: widget.isPinuno,
                              commAnnouncement: announcements[index],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isPinuno
          ? FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateAnnouncementPage(type: "Applicant"),
                  ),
                );
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
