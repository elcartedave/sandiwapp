import 'package:flutter/material.dart';
import 'package:sandiwapp/models/eventModel.dart';
import 'package:sandiwapp/models/formsModel.dart';
import 'package:sandiwapp/models/taskModel.dart';

class CalendarEvent {
  final String title;
  final String? content;
  final DateTime date;
  final TimeOfDay? time;
  final Event? event;
  final MyForm? form;
  final MyTask? task;

  CalendarEvent({
    required this.title,
    this.event,
    required this.date,
    this.time,
    this.content,
    this.form,
    this.task,
  });
}
