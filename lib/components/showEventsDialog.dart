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
import 'package:sandiwapp/providers/announcement_provider.dart';
import 'package:sandiwapp/providers/event_provider.dart';

class ShowEventDialog extends StatefulWidget {
  final Event event;
  const ShowEventDialog({required this.event, super.key});

  @override
  State<ShowEventDialog> createState() => _ShowEventDialogState();
}

class _ShowEventDialogState extends State<ShowEventDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: PatrickHand(text: "Event", fontSize: 24),
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
                      ShowEditEventDialog(event: widget.event));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: PatrickHand(text: "Delete", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ShowDeleteEventDialog(
                        event: widget.event,
                      ));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class ShowDeleteEventDialog extends StatefulWidget {
  const ShowDeleteEventDialog({required this.event, super.key});
  final Event event;
  @override
  State<ShowDeleteEventDialog> createState() => _ShowDeleteEventDialogState();
}

class _ShowDeleteEventDialogState extends State<ShowDeleteEventDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const PatrickHand(
        text: "Delete Event",
        fontSize: 20,
      ),
      backgroundColor: Colors.white,
      content: PatrickHand(
          text: "Are you sure you want to delete the event?", fontSize: 16),
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
                            .read<EventProvider>()
                            .deleteEvent(
                                widget.event.id!, widget.event.photoUrl!);
                        if (message == "") {
                          showCustomSnackBar(
                              context, "Event Successfully Deleted!", 85);
                          Navigator.pop(context);
                        } else {
                          showCustomSnackBar(context, message, 85);
                        }
                        Navigator.pop(context);
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

class ShowEditEventDialog extends StatefulWidget {
  final Event event;
  const ShowEditEventDialog({required this.event, super.key});

  @override
  State<ShowEditEventDialog> createState() => _ShowEditEventDialogState();
}

class _ShowEditEventDialogState extends State<ShowEditEventDialog> {
  late TextEditingController _titleController;
  late TextEditingController _placeController;
  late TextEditingController _feeController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late DateTime _selectedDate;
  late TimeOfDay? _selectedTime;
  final ScrollController _scrollController = ScrollController();
  File? _image;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _placeController = TextEditingController(text: widget.event.place);
    _feeController = TextEditingController(text: widget.event.fee);
    _selectedDate = widget.event.date;
    _selectedTime = TimeOfDay.fromDateTime(widget.event.date);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  Future<void> _pickImageAndScroll() async {
    File? pickedImage = await pickerImage();
    setState(() {
      _image = pickedImage;
    });
    if (_image != null) {
      scrollToEnd(_scrollController);
    }
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
      title: Text("Edit Event"),
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
                child: Text("Place", style: blackText)),
            MyTextField2(
                controller: _placeController,
                obscureText: false,
                hintText: '',
                maxLines: 5),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.topLeft,
                child: PatrickHandSC(text: "Date & Time", fontSize: 20)),
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
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.topLeft,
                child: PatrickHandSC(text: "Fee", fontSize: 20)),
            MyTextField2(
              controller: _feeController,
              isNumber: true,
              obscureText: false,
              hintText: '',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.topLeft,
                child: PatrickHandSC(text: "Photo", fontSize: 20)),
            WhiteButton(
              text: "Upload Picture of Event (or Place)",
              onTap: _pickImageAndScroll,
            ),
            if (_image == null && widget.event.photoUrl != "")
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ImageBuffer(
                  photoURL: widget.event.photoUrl!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
            if (_image == null && widget.event.photoUrl == "")
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(
                  'assets/images/base_image.png',
                  height: 200,
                  width: 200,
                ),
              ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.file(
                  _image!,
                  height: 200,
                  width: 200,
                ),
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

                            String message =
                                await context.read<EventProvider>().editEvent(
                                      _feeController.text,
                                      _image,
                                      _placeController.text,
                                      _titleController.text,
                                      eventDateTime,
                                      widget.event.photoUrl!,
                                      widget.event.id!,
                                    );
                            if (message == "") {
                              showCustomSnackBar(
                                  context, "Event Successfully Edited!", 85);
                              Navigator.of(context).pop();
                            } else {
                              showCustomSnackBar(context, message, 85);
                              setState(() {
                                _isLoading = false;
                              });
                            }
                            Navigator.pop(context);
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
