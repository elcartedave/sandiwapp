import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/statementModel.dart';
import 'package:sandiwapp/providers/statement_provider.dart';

class ShowStatementDialog extends StatefulWidget {
  final Statement statement;
  const ShowStatementDialog({required this.statement, super.key});

  @override
  State<ShowStatementDialog> createState() => _ShowStatementDialogState();
}

class _ShowStatementDialogState extends State<ShowStatementDialog> {
  bool _isLoading1 = false;
  bool _isLoading2 = false;

  @override
  Widget build(BuildContext context) {
    print(widget.statement.status);
    return AlertDialog(
      backgroundColor: Colors.white,
      scrollable: true,
      title: PatrickHand(text: widget.statement.title, fontSize: 24),
      content: Text(
        widget.statement.content,
        textAlign: TextAlign.justify,
      ),
      actions: [
        Column(
          children: [
            widget.statement.status != "Pending" &&
                    widget.statement.status != "Rejected"
                ? Container()
                : Column(
                    children: [
                      widget.statement.status != "Pending"
                          ? Container()
                          : _isLoading1
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                )
                              : BlackButton(
                                  text: "Unsend and Move to Drafts",
                                  onTap: () async {
                                    setState(() {
                                      _isLoading1 = true;
                                    });
                                    String message = await context
                                        .read<StatementProvider>()
                                        .submit(widget.statement.id!, false);
                                    if (message == '') {
                                      showCustomSnackBar(
                                          context, "Statement unsent!", 30);
                                      Navigator.pop(context);
                                    } else {
                                      showCustomSnackBar(context, message, 30);
                                    }
                                  },
                                ),
                      const SizedBox(height: 8),
                      _isLoading2
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : WhiteButton(
                              text: "Delete",
                              onTap: () async {
                                setState(() {
                                  _isLoading2 = true;
                                });
                                String message = await context
                                    .read<StatementProvider>()
                                    .deleteStatement(widget.statement.id!);
                                if (message == '') {
                                  showCustomSnackBar(
                                      context, "Statement deleted!", 30);
                                  Navigator.pop(context);
                                } else {
                                  showCustomSnackBar(context, message, 30);
                                }
                              },
                            ),
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MyTextButton(
                text: "Go Back",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
