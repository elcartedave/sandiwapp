import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/scrollDownAnimation.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/components/uploadImage.dart';
import 'package:sandiwapp/providers/event_provider.dart';

class CreateEventPage extends StatefulWidget {
  final bool? isApplicant;
  const CreateEventPage({this.isApplicant, super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _feeController = TextEditingController();
  File? _image;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _scrollController.dispose();
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black, // Selected date background color
              onPrimary: Colors.white, // Selected date text color
              onSurface: Colors.black, // Default text color
            ),
            dialogBackgroundColor: Colors.white, // Background color
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black, // Selected time background color
              onPrimary: Colors.white, // Selected time text color
              onSurface: Colors.black, // Default text color
            ),
            timePickerTheme: TimePickerThemeData(
              dialBackgroundColor: Colors.white, // Dial background color
              dialHandColor: Colors.black, // Dial hand color
              hourMinuteColor: WidgetStateColor.resolveWith((states) => states
                      .contains(WidgetState.selected)
                  ? Colors.black // Selected hour/minute background color
                  : Colors.white), // Unselected hour/minute background color
              hourMinuteTextColor: WidgetStateColor.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? Colors.white // Selected hour/minute text color
                      : Colors.black), // Unselected hour/minute text color
              dayPeriodTextColor: WidgetStateColor.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? Colors.white // Selected AM/PM text color
                      : Colors.black), // Unselected AM/PM text color
              dayPeriodColor: WidgetStateColor.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? Colors.black // Selected AM/PM background color
                      : Colors.white), // Unselected AM/PM background color
              helpTextStyle: TextStyle(color: Colors.black), // Help text color
              entryModeIconColor: Colors.black, // Entry mode icon color
            ),
            dialogBackgroundColor: Colors.white, // Background color
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null && pickedTime != _selectedTime)
      setState(() {
        _selectedTime = pickedTime;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "Gumawa ng Event",
          style: GoogleFonts.patrickHand(fontSize: 24),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            child: PatrickHandSC(text: "Title", fontSize: 20)),
                        MyTextField2(
                            controller: _titleController,
                            obscureText: false,
                            hintText: ''),
                        const SizedBox(height: 15),
                        Container(
                            alignment: Alignment.topLeft,
                            child: PatrickHandSC(
                                text: "Place (or link if online meeting)",
                                fontSize: 20)),
                        MyTextField2(
                          controller: _placeController,
                          obscureText: false,
                          hintText: '',
                        ),
                        const SizedBox(height: 15),
                        Container(
                            alignment: Alignment.topLeft,
                            child: PatrickHandSC(
                                text: "Date & Time", fontSize: 20)),
                        Row(
                          children: [
                            Expanded(
                              child: WhiteButton(
                                onTap: () => _selectDate(context),
                                text: _selectedDate == null
                                    ? 'Select Date'
                                    : "${_selectedDate!.toLocal()}"
                                        .split(' ')[0],
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
                        const SizedBox(height: 15),
                        Container(
                            alignment: Alignment.topLeft,
                            child: PatrickHandSC(
                                text: "Fee (0 if none)", fontSize: 20)),
                        MyTextField2(
                          controller: _feeController,
                          isNumber: true,
                          obscureText: false,
                          hintText: '',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 15),
                        Container(
                            alignment: Alignment.topLeft,
                            child: PatrickHandSC(text: "Photo", fontSize: 20)),
                        const SizedBox(height: 15),
                        WhiteButton(
                          text: "Upload Picture of Event (or Place)",
                          onTap: _pickImageAndScroll,
                        ),
                        const SizedBox(height: 15),
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
            ),
          ),
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlackButton(
                      text: "Gumawa",
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
                            late String message;
                            if (widget.isApplicant != null &&
                                widget.isApplicant == true) {
                              message = await context
                                  .read<EventProvider>()
                                  .createEventForApp(
                                      _feeController.text,
                                      _image,
                                      _placeController.text,
                                      _titleController.text,
                                      eventDateTime);
                            } else {
                              message = await context
                                  .read<EventProvider>()
                                  .createEvent(
                                      _feeController.text,
                                      _image,
                                      _placeController.text,
                                      _titleController.text,
                                      eventDateTime);
                            }
                            if (message == "") {
                              showCustomSnackBar(
                                  context, "Event Successfully Created!", 85);
                              Navigator.of(context).pop();
                            } else {
                              showCustomSnackBar(context, message, 85);
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          } else {
                            showCustomSnackBar(
                                context, "Please fill all fields", 85);
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      }),
                )
        ],
      ),
    );
  }
}
