import 'package:flutter/material.dart';
import 'package:linkable/linkable.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/showDialogs.dart';
import 'package:sandiwapp/models/announcementModel.dart';

class CommAnnouncementItem extends StatefulWidget {
  final bool isPinuno;
  final Announcement commAnnouncement;
  const CommAnnouncementItem(
      {required this.isPinuno, required this.commAnnouncement, super.key});

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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: widget.isPinuno
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: widget.isPinuno
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: widget.isPinuno
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.commAnnouncement.title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: widget.isPinuno
                            ? TextAlign.start
                            : TextAlign.center,
                      ),
                      Text(
                        dateFormatter(widget.commAnnouncement.date),
                        style: TextStyle(fontFamily: 'Inter', fontSize: 15),
                        textAlign: widget.isPinuno
                            ? TextAlign.start
                            : TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (widget.isPinuno)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => ShowAnnouncementDialog(
                              announcement: widget.commAnnouncement));
                    },
                    child: Icon(
                      Icons.more_vert,
                      size: 28,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Linkable(
              text: widget.commAnnouncement.content,
              style: TextStyle(fontFamily: 'Inter', fontSize: 15),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
