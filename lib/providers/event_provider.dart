import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sandiwapp/api/firebase_events_api.dart';

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
}
