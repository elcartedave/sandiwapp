import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/statementModel.dart';
import 'package:sandiwapp/providers/activity_provider.dart';
import 'package:sandiwapp/providers/statement_provider.dart';

class DeleteActivity extends StatefulWidget {
  final String id;
  const DeleteActivity({required this.id, super.key});

  @override
  State<DeleteActivity> createState() => _DeleteActivityState();
}

class _DeleteActivityState extends State<DeleteActivity> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: PatrickHand(text: "Draft", fontSize: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.delete),
            title: PatrickHand(text: "Delete Activity", fontSize: 20),
            onTap: () async {
              bool? result = await showDialog(
                  context: context,
                  builder: (context) => ShowDeleteActivityDialog(
                        id: widget.id,
                      ));
              Navigator.of(context).pop(result);
            },
          ),
        ],
      ),
    );
  }
}

class ShowDeleteActivityDialog extends StatefulWidget {
  final String id;
  const ShowDeleteActivityDialog({required this.id, super.key});

  @override
  State<ShowDeleteActivityDialog> createState() =>
      _ShowDeleteActivityDialogState();
}

class _ShowDeleteActivityDialogState extends State<ShowDeleteActivityDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const PatrickHand(text: "Delete Activity", fontSize: 20),
      backgroundColor: Colors.white,
      content: const PatrickHand(
          text: "Are you sure you want to delete this activity?", fontSize: 16),
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
                            .read<ActivityProvider>()
                            .deleteActivities(widget.id);
                        if (message == "") {
                          showCustomSnackBar(
                              context, "Activity Successfully Deleted!", 80);
                          Navigator.of(context).pop(true);
                        } else {
                          showCustomSnackBar(context, message, 80);
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
                    Navigator.of(context).pop(false);
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
