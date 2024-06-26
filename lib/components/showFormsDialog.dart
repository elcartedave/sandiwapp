import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/imageBuffer.dart';
import 'package:sandiwapp/components/scrollDownAnimation.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/components/uploadImage.dart';
import 'package:sandiwapp/models/eventModel.dart';
import 'package:sandiwapp/models/formsModel.dart';
import 'package:sandiwapp/providers/announcement_provider.dart';
import 'package:sandiwapp/providers/event_provider.dart';
import 'package:sandiwapp/providers/forms_provider.dart';

class ShowFormsDialog extends StatefulWidget {
  final MyForm form;
  const ShowFormsDialog({required this.form, super.key});

  @override
  State<ShowFormsDialog> createState() => _ShowFormsDialogState();
}

class _ShowFormsDialogState extends State<ShowFormsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: PatrickHand(text: "Form", fontSize: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: PatrickHand(text: "Edit", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ShowEditFormDialog(form: widget.form));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: PatrickHand(text: "Delete", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ShowDeleteFormDialog(
                        form: widget.form,
                      ));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class ShowDeleteFormDialog extends StatefulWidget {
  const ShowDeleteFormDialog({required this.form, super.key});
  final MyForm form;
  @override
  State<ShowDeleteFormDialog> createState() => _ShowDeleteFormDialogState();
}

class _ShowDeleteFormDialogState extends State<ShowDeleteFormDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const PatrickHand(
        text: "Delete Form",
        fontSize: 20,
      ),
      backgroundColor: Colors.white,
      content: PatrickHand(
          text: "Are you sure you want to delete the form?", fontSize: 16),
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
                            .read<FormsProvider>()
                            .deleteForms(widget.form.id!);
                        if (message == "") {
                          showCustomSnackBar(
                              context, "Form Successfully Deleted!", 85);
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

class ShowEditFormDialog extends StatefulWidget {
  final MyForm form;
  const ShowEditFormDialog({required this.form, super.key});

  @override
  State<ShowEditFormDialog> createState() => _ShowEditFormDialogState();
}

class _ShowEditFormDialogState extends State<ShowEditFormDialog> {
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late DateTime _selectedDate;
  late TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.form.title);
    _urlController = TextEditingController(text: widget.form.url);
    _selectedDate = widget.form.date;
    _selectedTime = TimeOfDay.fromDateTime(widget.form.date);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime!,
    );
    if (pickedTime != null && pickedTime != _selectedTime)
      setState(() {
        _selectedTime = pickedTime;
      });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Form"),
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
                child: Text(
                    "Link of Form (ex. https://forms.gle/ptPbdUdjbB1gfLaS6)",
                    style: blackText)),
            MyTextField2(
                controller: _urlController,
                obscureText: false,
                hintText: '',
                maxLines: 5),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.topLeft,
                child: PatrickHandSC(text: "Due Date & Time", fontSize: 20)),
            Row(
              children: [
                Expanded(
                  child: WhiteButton(
                    onTap: () => _selectDate(context),
                    text: _selectedDate == null
                        ? 'Select Date'
                        : "${_selectedDate!.toLocal()}".split(' ')[0],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: WhiteButton(
                    onTap: () => _selectTime(context),
                    text: _selectedTime == null
                        ? 'Select Time'
                        : _selectedTime!.format(context),
                  ),
                ),
              ],
            ),
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
                          if (_selectedDate != null && _selectedTime != null) {
                            DateTime eventDateTime = DateTime(
                              _selectedDate!.year,
                              _selectedDate!.month,
                              _selectedDate!.day,
                              _selectedTime!.hour,
                              _selectedTime!.minute,
                            );

                            if (eventDateTime.isBefore(DateTime.now())) {
                              showCustomSnackBar(
                                  context,
                                  "Date and time cannot be earlier than now!",
                                  80);
                              setState(() {
                                _isLoading = false;
                              });
                              return;
                            }

                            if (!_urlController.text.contains("https") &&
                                !_urlController.text.contains(".com")) {
                              showCustomSnackBar(
                                  context,
                                  "Please enter a valid link. Make sure to have 'https://' at the beginning of the link",
                                  80);
                              setState(() {
                                _isLoading = false;
                              });
                              return;
                            }

                            String message = await context
                                .read<FormsProvider>()
                                .editForms(_titleController.text, eventDateTime,
                                    _urlController.text, widget.form.id!);
                            if (message == "") {
                              showCustomSnackBar(
                                  context, "Form Successfully Edited!", 85);
                              Navigator.of(context).pop();
                            } else {
                              showCustomSnackBar(context, message, 85);
                              setState(() {
                                _isLoading = false;
                              });
                            }
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
