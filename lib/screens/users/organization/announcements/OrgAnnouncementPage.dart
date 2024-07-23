import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkable/linkable.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/showDialogs.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/announcementModel.dart';
import 'package:sandiwapp/providers/announcement_provider.dart';

class OrgAnnouncementPage extends StatefulWidget {
  final Announcement announcement;
  final bool? isPinuno;
  const OrgAnnouncementPage(
      {this.isPinuno, required this.announcement, super.key});

  @override
  State<OrgAnnouncementPage> createState() => _OrgAnnouncementPageState();
}

class _OrgAnnouncementPageState extends State<OrgAnnouncementPage> {
  @override
  Widget build(BuildContext context) {
    print("isPinuno: ${widget.isPinuno}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: widget.isPinuno == null || widget.isPinuno == false
            ? Text(
                "Announcement",
                style: GoogleFonts.patrickHand(fontSize: 24),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Announcement",
                    style: GoogleFonts.patrickHand(fontSize: 24),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (widget.isPinuno!) {
                        showDialog(
                            context: context,
                            builder: (context) => ShowAnnouncementDialog(
                                isGeneral: true,
                                announcement: widget.announcement));
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  widget.announcement.title,
                  style: GoogleFonts.patrickHand(fontSize: 24, height: 1),
                  textAlign: TextAlign.center,
                ),
              ),
              PatrickHandSC(
                  text: dateFormatter(widget.announcement.date), fontSize: 15),
              const SizedBox(height: 10),
              Linkable(
                text: widget.announcement.content,
                style: GoogleFonts.patrickHand(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
