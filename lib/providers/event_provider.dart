import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sandiwapp/api/firebase_events_api.dart';
import 'package:sandiwapp/components/uploadImage.dart';

class EventProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _eventsStream;
  Stream<QuerySnapshot> get events => _eventsStream;

  late Stream<QuerySnapshot> _appEventsStream;
  Stream<QuerySnapshot> get appEvents => _appEventsStream;
  FirebaseEventsAPI firebaseService = FirebaseEventsAPI();

  EventProvider() {
    fetchEvents();
    fetchAppEvents();
  }

  Stream<QuerySnapshot> fetchEvents() {
    _eventsStream = firebaseService.getAllEvents();
    notifyListeners();
    return _eventsStream;
  }

  Stream<QuerySnapshot> fetchAppEvents() {
    _appEventsStream = firebaseService.getAppEvents();
    notifyListeners();
    return _appEventsStream;
  }

  Future<void> toggleGoing(String eventId, bool going) async {
    await firebaseService.toggleGoing(eventId, going);
  }

  Future<String> createEvent(String fee, File? image, String place,
      String title, DateTime dateTime) async {
    late String photoURL;
    if (image == null) {
      photoURL = "";
    } else {
      photoURL = await uploadImage(image, 'events');
    }
    return firebaseService.createEvent(fee, photoURL, place, title, dateTime);
  }

  Future<String> createEventForApp(String fee, File? image, String place,
      String title, DateTime dateTime) async {
    late String photoURL;
    if (image == null) {
      photoURL = "";
    } else {
      photoURL = await uploadImage(image, 'events');
    }
    return firebaseService.createEventForApp(
        fee, photoURL, place, title, dateTime);
  }

  Future<String> editEvent(String fee, File? image, String place, String title,
      DateTime dateTime, String photoURL, String id) async {
    late String newPhotoURL;
    if (image == null) {
      newPhotoURL = photoURL;
    } else {
      await deleteFileFromUrl(photoURL);
      newPhotoURL = await (uploadImage(image, 'events'));
    }
    return firebaseService.editEvent(
        fee, newPhotoURL, place, title, dateTime, id);
  }

  Future<String> deleteEvent(String id, String photoURL) async {
    if (photoURL != "") await deleteFileFromUrl(photoURL);
    return await firebaseService.deleteEvent(id);
  }
}
