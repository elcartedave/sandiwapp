import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/statementModel.dart';
import 'package:sandiwapp/providers/statement_provider.dart';

class DeleteDialog extends StatefulWidget {
  final Statement statement;
  const DeleteDialog({required this.statement, super.key});

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
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
            title: PatrickHand(text: "Delete Draft", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ShowDeletePostDialog(
                        statement: widget.statement,
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
  final Statement statement;
  const ShowDeletePostDialog({required this.statement, super.key});

  @override
  State<ShowDeletePostDialog> createState() => _ShowDeletePostDialogState();
}

class _ShowDeletePostDialogState extends State<ShowDeletePostDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const PatrickHand(text: "Delete Draft", fontSize: 20),
      backgroundColor: Colors.white,
      content: const PatrickHand(
          text: "Are you sure you want to delete this draft?", fontSize: 16),
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
                            .read<StatementProvider>()
                            .deleteStatement(widget.statement.id!);
                        if (message == "") {
                          showCustomSnackBar(
                              context, "Draft Successfully Deleted!", 85);
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
