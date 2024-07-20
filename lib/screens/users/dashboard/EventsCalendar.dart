import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/manageActivity.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/activityModel.dart';
import 'package:sandiwapp/models/calendarEvent.dart';
import 'package:sandiwapp/models/eventModel.dart';
import 'package:sandiwapp/models/formsModel.dart';
import 'package:sandiwapp/models/taskModel.dart';
import 'package:sandiwapp/providers/activity_provider.dart';
import 'package:sandiwapp/providers/event_provider.dart';
import 'package:sandiwapp/providers/forms_provider.dart';
import 'package:sandiwapp/providers/task_provider.dart';
import 'package:sandiwapp/screens/users/organization/ViewEventPage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsCalendar extends StatefulWidget {
  final String lupon;
  final bool isPinuno;
  const EventsCalendar(
      {required this.isPinuno, required this.lupon, super.key});

  @override
  State<EventsCalendar> createState() => _EventsCalendarState();
}

class _EventsCalendarState extends State<EventsCalendar> {
  DateTime today = DateTime.now();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Map<DateTime, List<CalendarEvent>> _events;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  late Stream<QuerySnapshot> _activityStream;
  late Stream<QuerySnapshot> _eventsStream;
  late Stream<QuerySnapshot> _formsStream;
  late Stream<QuerySnapshot> _tasksStream;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {};
    _activityStream =
        context.read<ActivityProvider>().fetchActivities(widget.lupon);
    _eventsStream = context.read<EventProvider>().events;
    _formsStream = context.read<FormsProvider>().forms;
    _tasksStream = context.read<TaskProvider>().fetchTasks();
    _initializeEvents();
  }

  void _initializeEvents() async {
    QuerySnapshot activitySnapshot = await _activityStream.first;
    QuerySnapshot eventSnapshot = await _eventsStream.first;
    QuerySnapshot formSnapshot = await _formsStream.first;
    QuerySnapshot tasksSnapshot = await _tasksStream.first;

    List<Activity> activities = activitySnapshot.docs.map((doc) {
      return Activity.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    List<Event> myEvents = eventSnapshot.docs.map((doc) {
      return Event.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    List<MyForm> myForms = formSnapshot.docs.map((doc) {
      return MyForm.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    List<MyTask> myTasks = tasksSnapshot.docs.map((doc) {
      return MyTask.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    setState(() {
      for (var activity in activities) {
        DateTime date = _normalizeDate(activity.date);
        CalendarEvent calendarEvent = CalendarEvent(
            title: activity.title,
            date: activity.date,
            content: activity.content,
            id: activity.id!);
        if (_events[date] == null) _events[date] = [];
        _events[date]!.add(calendarEvent);
      }

      for (var task in myTasks) {
        DateTime date = _normalizeDate(task.dueDate);
        CalendarEvent calendarEvent = CalendarEvent(
          title: task.task,
          date: task.dueDate,
          content: dateFormatter(task.dueDate),
          task: task,
        );
        if (_events[date] == null) _events[date] = [];
        _events[date]!.add(calendarEvent);
      }

      for (var myEvent in myEvents) {
        DateTime date = _normalizeDate(myEvent.date);
        CalendarEvent calendarEvent = CalendarEvent(
          title: myEvent.title,
          date: myEvent.date,
          event: myEvent,
          content: myEvent.place,
        );
        if (_events[date] == null) _events[date] = [];
        _events[date]!.add(calendarEvent);
      }

      for (var myForm in myForms) {
        DateTime date = _normalizeDate(myForm.date);
        CalendarEvent calendarEvent = CalendarEvent(
          title: myForm.title,
          date: myForm.date,
          content: myForm.url,
          form: myForm,
        );
        if (_events[date] == null) _events[date] = [];
        _events[date]!.add(calendarEvent);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<CalendarEvent> _getActivitiesForDay(DateTime day) {
    DateTime normalizedDay = _normalizeDate(day);
    if (_events[normalizedDay] != null) {
      _events[normalizedDay]!.sort((a, b) => a.date.compareTo(b.date));
      return _events[normalizedDay]!;
    } else {
      return [];
    }
  }

  void _refreshData() {
    _initializeEvents();
  }

  void _showAddActivityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          scrollable: true,
          title: Text("Task for ${petsa(_selectedDay!)}"),
          content: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
                    hintText: 'Title',
                  ),
                  const SizedBox(height: 10),
                  Container(
                      alignment: Alignment.topLeft,
                      child: PatrickHandSC(text: "Content", fontSize: 20)),
                  MyTextField2(
                    controller: _contentController,
                    obscureText: false,
                    hintText: 'Content',
                  ),
                  const SizedBox(height: 10),
                  Container(
                      alignment: Alignment.topLeft,
                      child: PatrickHandSC(text: "Time", fontSize: 20)),
                  WhiteButton(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors
                                    .black, // Selected time background color
                                onPrimary:
                                    Colors.white, // Selected time text color
                                onSurface: Colors.black, // Default text color
                              ),
                              timePickerTheme: TimePickerThemeData(
                                dialBackgroundColor:
                                    Colors.white, // Dial background color
                                dialHandColor: Colors.black, // Dial hand color
                                hourMinuteColor: WidgetStateColor.resolveWith(
                                    (states) => states
                                            .contains(WidgetState.selected)
                                        ? Colors
                                            .black // Selected hour/minute background color
                                        : Colors
                                            .white), // Unselected hour/minute background color
                                hourMinuteTextColor: WidgetStateColor
                                    .resolveWith((states) => states
                                            .contains(WidgetState.selected)
                                        ? Colors
                                            .white // Selected hour/minute text color
                                        : Colors
                                            .black), // Unselected hour/minute text color
                                dayPeriodTextColor: WidgetStateColor
                                    .resolveWith((states) => states
                                            .contains(WidgetState.selected)
                                        ? Colors
                                            .white // Selected AM/PM text color
                                        : Colors
                                            .black), // Unselected AM/PM text color
                                dayPeriodColor: WidgetStateColor.resolveWith(
                                    (states) => states
                                            .contains(WidgetState.selected)
                                        ? Colors
                                            .black // Selected AM/PM background color
                                        : Colors
                                            .white), // Unselected AM/PM background color
                                helpTextStyle: TextStyle(
                                    color: Colors.black), // Help text color
                                entryModeIconColor:
                                    Colors.black, // Entry mode icon color
                              ),
                              dialogBackgroundColor:
                                  Colors.white, // Background color
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedTime != null && pickedTime != _selectedTime) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    text: _selectedTime == null
                        ? 'Select Time'
                        : _selectedTime!.format(context),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : BlackButton(
                          text: "Idagdag",
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedTime != null) {
                                setState(() {
                                  _isLoading = true;
                                });

                                DateTime eventDateTime = DateTime(
                                  _selectedDay!.year,
                                  _selectedDay!.month,
                                  _selectedDay!.day,
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

                                final newActivity = Activity(
                                  title: _titleController.text,
                                  content: _contentController.text,
                                  date: eventDateTime,
                                  lupon: widget.lupon,
                                );
                                DateTime date =
                                    _normalizeDate(newActivity.date);
                                CalendarEvent calendarEvent = CalendarEvent(
                                  title: newActivity.title,
                                  date: newActivity.date,
                                  content: newActivity.content,
                                );
                                if (_events[date] == null) _events[date] = [];
                                _events[date]!.add(calendarEvent);
                                String message = await context
                                    .read<ActivityProvider>()
                                    .createActivity(newActivity);
                                if (message == "") {
                                  showCustomSnackBar(context,
                                      "Activity successfully added!", 85);
                                  Navigator.pop(context);
                                  _refreshData();
                                } else {
                                  showCustomSnackBar(context, message, 85);
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              } else {
                                showCustomSnackBar(
                                    context, "Please enter a time!", 85);
                              }
                            }
                          },
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: WhiteButton(
                    text: "Bumalik",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: Container(color: Colors.white),
      ),
      Positioned.fill(
        child: Image.asset(
          "assets/images/bg1.png",
          fit: BoxFit.cover,
          opacity: AlwaysStoppedAnimation(0.5),
        ),
      ),
      Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        floatingActionButton: !widget.isPinuno
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.black,
                shape: CircleBorder(),
                onPressed: () => _showAddActivityDialog(context),
                child: const Icon(Icons.add, color: Colors.white),
              ),
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent,
          title: PatrickHand(text: "Talaan ng Events ng Lupon", fontSize: 24),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              TableCalendar(
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                availableGestures: AvailableGestures.all,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color.fromARGB(83, 0, 0, 0),
                    shape: BoxShape.circle,
                  ),
                ),
                onDaySelected: _onDaySelected,
                focusedDay: _focusedDay,
                firstDay: DateTime.now(),
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                eventLoader: _getActivitiesForDay,
                lastDay: DateTime(2101),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "Mga Ganap sa ${petsa(_selectedDay!)}",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: StreamBuilder(
                  stream: _activityStream,
                  builder: (context, activitySnapshot) {
                    if (activitySnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (activitySnapshot.hasError) {
                      return Center(
                          child: Text("Error: ${activitySnapshot.error}"));
                    }

                    return StreamBuilder(
                      stream: _eventsStream,
                      builder: (context, eventSnapshot) {
                        if (eventSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: Colors.black,
                          ));
                        }
                        if (eventSnapshot.hasError) {
                          return Center(
                              child: Text("Error: ${eventSnapshot.error}"));
                        }

                        return StreamBuilder(
                            stream: _tasksStream,
                            builder: (context, taskSnapshot) {
                              if (taskSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (taskSnapshot.hasError) {
                                return Center(
                                    child:
                                        Text("Error: ${taskSnapshot.error}"));
                              }
                              List<CalendarEvent> activitiesForDay =
                                  _getActivitiesForDay(_selectedDay!);

                              return activitiesForDay.isEmpty
                                  ? Center(
                                      child: PatrickHand(
                                          text: "Walang ganap sa araw na ito",
                                          fontSize: 14))
                                  : ListView.builder(
                                      itemCount: activitiesForDay.length,
                                      itemBuilder: (context, index) {
                                        CalendarEvent calendarEvent =
                                            activitiesForDay[index];

                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            leading: Text(hourFormatter(
                                                calendarEvent.date)),
                                            onLongPress: () async {
                                              if (calendarEvent.event == null &&
                                                  calendarEvent.form == null &&
                                                  calendarEvent.task == null) {
                                                bool? result = await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        DeleteActivity(
                                                            id: calendarEvent
                                                                .id!));
                                                if (result == true) {
                                                  _events[calendarEvent.date]!
                                                      .remove(calendarEvent);
                                                }
                                              }
                                            },
                                            onTap: () {
                                              if (calendarEvent.event != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewEventPage(
                                                      isPast: false,
                                                      event:
                                                          calendarEvent.event!,
                                                      isPinuno: widget.isPinuno,
                                                    ),
                                                  ),
                                                );
                                              }
                                              if (calendarEvent.form != null) {
                                                launchUrl(
                                                    Uri.parse(calendarEvent
                                                        .form!.url),
                                                    mode: LaunchMode
                                                        .platformDefault);
                                              }
                                            },
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    calendarEvent.event != null
                                                        ? "(EVENT) ${calendarEvent.title}"
                                                        : calendarEvent.form !=
                                                                null
                                                            ? "(FORM) ${calendarEvent.title}"
                                                            : calendarEvent
                                                                        .task !=
                                                                    null
                                                                ? "(ASSIGNED TASK) ${calendarEvent.title}"
                                                                : "(LUPON ACTIVITY) ${calendarEvent.title}",
                                                    style:
                                                        GoogleFonts.patrickHand(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                PatrickHand(
                                                    text:
                                                        calendarEvent.content!,
                                                    fontSize: 12)
                                              ],
                                            ),
                                            trailing: calendarEvent.event !=
                                                    null
                                                ? Icon(Icons.meeting_room)
                                                : calendarEvent.form != null
                                                    ? Icon(Icons.text_snippet)
                                                    : calendarEvent.task != null
                                                        ? Icon(Icons
                                                            .checklist_sharp)
                                                        : Icon(Icons
                                                            .calendar_month),
                                          ),
                                        );
                                      },
                                    );
                            });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
