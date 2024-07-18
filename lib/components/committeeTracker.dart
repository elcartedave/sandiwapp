import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/providers/link_provider.dart';
import 'package:validator_regex/validator_regex.dart';

class CommitteeTracker extends StatefulWidget {
  final String lupon;
  final bool isPinuno;
  const CommitteeTracker(
      {required this.isPinuno, required this.lupon, super.key});

  @override
  State<CommitteeTracker> createState() => _CommitteeTrackerState();
}

class _CommitteeTrackerState extends State<CommitteeTracker> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPinuno) {
      return AlertDialog(
        backgroundColor: Colors.white,
        scrollable: true,
        title: const Column(
          children: [
            PatrickHandSC(text: "Add Tracker", fontSize: 24),
            PatrickHand(
                text: "Tracker link should be final before adding",
                fontSize: 16)
          ],
        ),
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                      "Link of Tracker (ex. https://docs.google.com/ptPbdUdjbB1gfLaS6)",
                      style: blackText)),
              MyTextField2(
                controller: _urlController,
                obscureText: false,
                hintText: '',
                isURL: true,
              ),
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
                        text: "I-add",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            String message = await context
                                .read<LinkProvider>()
                                .createTracker(
                                    _urlController.text, widget.lupon);
                            if (message == "") {
                              showCustomSnackBar(
                                  context, "Tracker Successfully Added!", 85);
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
    return AlertDialog(
      backgroundColor: Colors.white,
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: PatrickHand(text: "Wala pang tracker!", fontSize: 24),
          ),
        ],
      ),
      actions: [
        WhiteButton(
          text: "Bumalik",
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
