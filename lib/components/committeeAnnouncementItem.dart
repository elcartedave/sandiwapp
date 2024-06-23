import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/models/announcementModel.dart';

class CommAnnouncementItem extends StatefulWidget {
  final Announcement commAnnouncement;
  const CommAnnouncementItem({required this.commAnnouncement, super.key});

  @override
  State<CommAnnouncementItem> createState() => _CommAnnouncementItemState();
}

class _CommAnnouncementItemState extends State<CommAnnouncementItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(
              widget.commAnnouncement.title,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.commAnnouncement.date.year.toString()}-${widget.commAnnouncement.date.month.toString().padLeft(2, '0')}-${widget.commAnnouncement.date.day.toString().padLeft(2, '0')} ${widget.commAnnouncement.date.hour.toString().padLeft(2, '0')}:${widget.commAnnouncement.date.minute.toString().padLeft(2, '0')}",
              style: TextStyle(fontFamily: 'Inter', fontSize: 15),
            ),
            const SizedBox(height: 10),
            Text(
              widget.commAnnouncement.content,
              style: TextStyle(fontFamily: 'Inter', fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
