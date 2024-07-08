import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/linksModel.dart';
import 'package:sandiwapp/providers/link_provider.dart';

class ShowPostDialog extends StatefulWidget {
  final Link link;
  const ShowPostDialog({required this.link, super.key});

  @override
  State<ShowPostDialog> createState() => _ShowPostDialogState();
}

class _ShowPostDialogState extends State<ShowPostDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: PatrickHand(text: "Post", fontSize: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.delete),
            title: PatrickHand(text: "Delete", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ShowDeletePostDialog(
                        link: widget.link,
                      ));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class ShowDeletePostDialog extends StatefulWidget {
  final Link link;
  const ShowDeletePostDialog({required this.link, super.key});

  @override
  State<ShowDeletePostDialog> createState() => _ShowDeletePostDialogState();
}

class _ShowDeletePostDialogState extends State<ShowDeletePostDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const PatrickHand(text: "Delete Post", fontSize: 20),
      backgroundColor: Colors.white,
      content: const PatrickHand(
          text: "Are you sure you want to delete this post?", fontSize: 16),
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
                              context, "Post Successfully Deleted!", 85);
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
