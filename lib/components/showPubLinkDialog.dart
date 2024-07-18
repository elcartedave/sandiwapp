import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/linksModel.dart';
import 'package:sandiwapp/providers/link_provider.dart';
import 'package:validator_regex/validator_regex.dart';

class ShowPubLinkDialog extends StatefulWidget {
  final Link pubLink;
  const ShowPubLinkDialog({required this.pubLink, super.key});

  @override
  State<ShowPubLinkDialog> createState() => _ShowPubLinkDialogState();
}

class _ShowPubLinkDialogState extends State<ShowPubLinkDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: PatrickHand(text: "Pub Link", fontSize: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: PatrickHand(text: "Edit", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) =>
                      ShowEditLinkDialog(link: widget.pubLink));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: PatrickHand(text: "Delete", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ShowDeleteLinkDialog(
                        link: widget.pubLink,
                      ));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class ShowDeleteLinkDialog extends StatefulWidget {
  final Link link;
  const ShowDeleteLinkDialog({required this.link, super.key});

  @override
  State<ShowDeleteLinkDialog> createState() => _ShowDeleteLinkDialogState();
}

class _ShowDeleteLinkDialogState extends State<ShowDeleteLinkDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const PatrickHand(text: "Delete Link", fontSize: 20),
      backgroundColor: Colors.white,
      content: const PatrickHand(
          text: "Are you sure you want to delete this link?", fontSize: 16),
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
                            .read<LinkProvider>()
                            .deleteLink(widget.link.id!);
                        if (message == "") {
                          showCustomSnackBar(
                              context, "Link Successfully Deleted!", 85);
                          Navigator.pop(context);
                        } else {
                          showCustomSnackBar(context, message, 85);
                        }
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

class ShowEditLinkDialog extends StatefulWidget {
  final Link link;
  const ShowEditLinkDialog({required this.link, super.key});

  @override
  State<ShowEditLinkDialog> createState() => _ShowEditLinkDialogState();
}

class _ShowEditLinkDialogState extends State<ShowEditLinkDialog> {
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.link.title);
    _urlController = TextEditingController(text: widget.link.url);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Edit Link"),
      backgroundColor: Colors.white,
      content: Form(
        key: _formKey,
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
                child: Text(
                    "Link of Pub (ex. https://canva.com/ptPbdUdjbB1gfLaS6)",
                    style: blackText)),
            MyTextField2(
                controller: _urlController,
                obscureText: false,
                hintText: '',
                isURL: true,
                maxLines: 5),
            const SizedBox(height: 10),
          ],
        ),
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
                              .read<LinkProvider>()
                              .editLink(widget.link.id!, _titleController.text,
                                  _urlController.text);
                          if (message == "") {
                            showCustomSnackBar(
                                context, "Link Successfully Edited!", 85);
                            Navigator.of(context).pop();
                          } else {
                            showCustomSnackBar(context, message, 85);
                            setState(() {
                              _isLoading = false;
                            });
                          }
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
