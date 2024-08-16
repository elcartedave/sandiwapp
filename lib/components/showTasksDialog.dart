import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/taskModel.dart';
import 'package:sandiwapp/providers/task_provider.dart';

class ShowTaskDialog extends StatefulWidget {
  final MyTask task;
  const ShowTaskDialog({required this.task, super.key});

  @override
  State<ShowTaskDialog> createState() => _ShowTaskDialogState();
}

class _ShowTaskDialogState extends State<ShowTaskDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: PatrickHand(text: "Task", fontSize: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: PatrickHand(text: "Edit", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ShowEditTaskDialog(task: widget.task));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: PatrickHand(text: "Delete", fontSize: 20),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ShowDeleteTaskDialog(
                        task: widget.task,
                      ));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class ShowDeleteTaskDialog extends StatefulWidget {
  const ShowDeleteTaskDialog({required this.task, super.key});
  final MyTask task;
  @override
  State<ShowDeleteTaskDialog> createState() => _ShowDeleteTaskDialogState();
}

class _ShowDeleteTaskDialogState extends State<ShowDeleteTaskDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const PatrickHand(
        text: "Delete task",
        fontSize: 20,
      ),
      backgroundColor: Colors.white,
      content: PatrickHand(
          text: "Are you sure you want to delete the task?", fontSize: 16),
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
                            .read<TaskProvider>()
                            .deleteaTask(widget.task.id!);
                        if (message == "") {
                          showCustomSnackBar(
                              context, "Task Successfully Deleted!", 85);
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

class ShowEditTaskDialog extends StatefulWidget {
  final MyTask task;
  const ShowEditTaskDialog({required this.task, super.key});

  @override
  State<ShowEditTaskDialog> createState() => _ShowEditTaskDialogState();
}

class _ShowEditTaskDialogState extends State<ShowEditTaskDialog> {
  late TextEditingController _taskController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late DateTime _selectedDate;
  late TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task.task);
    _selectedDate = widget.task.dueDate;
    _selectedTime = TimeOfDay.fromDateTime(widget.task.dueDate);
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
      initialTime: _selectedTime!,
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
    return AlertDialog(
      title: Text("Edit Task"),
      backgroundColor: Colors.white,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                child: Text("Task", style: blackText)),
            MyTextField2(
                controller: _taskController, obscureText: false, hintText: ''),
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

                            String message = await context
                                .read<TaskProvider>()
                                .editTask(widget.task.id!, eventDateTime,
                                    _taskController.text);
                            if (message == "") {
                              showCustomSnackBar(
                                  context, "TaskSuccessfully Edited!", 85);
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
