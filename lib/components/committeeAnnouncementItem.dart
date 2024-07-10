import 'package:flutter/material.dart';
import 'package:sandiwapp/components/dateformatter.dart';
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
              textAlign: TextAlign.center,
            ),
            Text(
              dateFormatter(widget.commAnnouncement.date),
              style: TextStyle(fontFamily: 'Inter', fontSize: 15),
            ),
            const SizedBox(height: 10),
            Text(
              widget.commAnnouncement.content,
              style: TextStyle(fontFamily: 'Inter', fontSize: 15),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
