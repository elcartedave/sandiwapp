import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/announcementModel.dart';
import 'package:sandiwapp/providers/announcement_provider.dart';

class ShowAnnouncementDialog extends StatefulWidget {
  final Announcement announcement;
  final bool? isGeneral;
  const ShowAnnouncementDialog(
      {this.isGeneral, required this.announcement, super.key});

  @override
  State<ShowAnnouncementDialog> createState() => _ShowAnnouncementDialogState();
}

class _ShowAnnouncementDialogState extends State<ShowAnnouncementDialog> {
  @override
  Widget build(BuildContext context) {
    bool _isGeneral = widget.isGeneral ?? false;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: PatrickHand(text: "Announcement", fontSize: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: PatrickHand(text: "Edit", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ShowEditDialog(
                      isGeneral: _isGeneral,
                      announcement: widget.announcement));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: PatrickHand(text: "Delete", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ShowDeleteDialog(
                        announcement: widget.announcement,
                        isGeneral: _isGeneral,
                      ));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class ShowDeleteDialog extends StatefulWidget {
  const ShowDeleteDialog(
      {this.isGeneral, required this.announcement, super.key});
  final Announcement announcement;
  final bool? isGeneral;
  @override
  State<ShowDeleteDialog> createState() => _ShowDeleteDialogState();
}

class _ShowDeleteDialogState extends State<ShowDeleteDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const PatrickHand(
        text: "Delete Announcement",
        fontSize: 20,
      ),
      backgroundColor: Colors.white,
      content: PatrickHand(
          text: "Are you sure you want to delete the announcement?",
          fontSize: 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : BlackButton(
                      text: "Yes",
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String message = await context
                            .read<AnnouncementProvider>()
                            .deleteAnnouncement(widget.announcement.id!);
                        if (message == "") {
                          showCustomSnackBar(context,
                              "Announcement Successfully Deleted!", 85);
                          Navigator.pop(context);
                        } else {
                          showCustomSnackBar(context, message, 85);
                        }
                        widget.isGeneral == true
                            ? Navigator.pop(context)
                            : null;
                      },
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Center(
                child: WhiteButton(
                  text: "No",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class ShowEditDialog extends StatefulWidget {
  final Announcement announcement;
  final bool? isGeneral;
  const ShowEditDialog({this.isGeneral, required this.announcement, super.key});

  @override
  State<ShowEditDialog> createState() => _ShowEditDialogState();
}

class _ShowEditDialogState extends State<ShowEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.announcement.title);
    _contentController =
        TextEditingController(text: widget.announcement.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("isGeneral: ${widget.isGeneral}");
    return AlertDialog(
      title: Text("Edit Announcement"),
      backgroundColor: Colors.white,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                child: Text("Title", style: blackText)),
            MyTextField2(
                controller: _titleController, obscureText: false, hintText: ''),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.topLeft,
                child: Text("Content", style: blackText)),
            MyTextField2(
                controller: _contentController,
                obscureText: false,
                hintText: '',
                maxLines: 5)
          ],
        )),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : BlackButton(
                      text: "I-update",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          String message = await context
                              .read<AnnouncementProvider>()
                              .editAnnouncement(
                                  _titleController.text,
                                  _contentController.text,
                                  widget.announcement.id!);
                          if (message == "") {
                            showCustomSnackBar(context,
                                "Announcement Successfully Edited!", 85);
                            Navigator.pop(context);
                          } else {
                            showCustomSnackBar(context, message, 85);
                          }
                          widget.isGeneral == true
                              ? Navigator.pop(context)
                              : null;
                        }
                      },
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Center(
                child: WhiteButton(
                  text: "Bumalik",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
