import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sandiwapp/api/firebase_events_api.dart';
import 'package:sandiwapp/components/uploadImage.dart';

class EventProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _eventsStream;
  Stream<QuerySnapshot> get events => _eventsStream;
  FirebaseEventsAPI firebaseService = FirebaseEventsAPI();

  EventProvider() {
    fetchEvents();
  }

  Stream<QuerySnapshot> fetchEvents() {
    _eventsStream = firebaseService.getAllEvents();
    notifyListeners();
    return _eventsStream;
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
