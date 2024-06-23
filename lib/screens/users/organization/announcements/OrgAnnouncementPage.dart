import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/announcementModel.dart';

class OrgAnnouncementPage extends StatefulWidget {
  final Announcement announcement;
  const OrgAnnouncementPage({required this.announcement, super.key});

  @override
  State<OrgAnnouncementPage> createState() => _OrgAnnouncementPageState();
}

class _OrgAnnouncementPageState extends State<OrgAnnouncementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "Announcement",
          style: GoogleFonts.patrickHand(fontSize: 24),
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
                  text:
                      "${widget.announcement.date.year.toString()}-${widget.announcement.date.month.toString().padLeft(2, '0')}-${widget.announcement.date.day.toString().padLeft(2, '0')} ${widget.announcement.date.hour.toString().padLeft(2, '0')}:${widget.announcement.date.minute.toString().padLeft(2, '0')}",
                  fontSize: 15),
              const SizedBox(height: 10),
              PatrickHand(text: widget.announcement.content, fontSize: 20)
            ],
          ),
        ),
      ),
    );
  }
}
