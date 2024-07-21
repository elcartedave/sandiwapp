import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/api/firebase_auth_api.dart';
import 'package:sandiwapp/api/firebase_user_api.dart';

class FirebaseEventsAPI {
  final FirebaseAuthAPI firebaseAuthAPI = FirebaseAuthAPI();
  final FirebaseUserAPI firebaseUserAPI = FirebaseUserAPI();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllEvents() {
    return _firestore.collection('events').snapshots();
  }

  Stream<QuerySnapshot> getAppEvents() {
    return _firestore
        .collection('events')
        .where('forApp', isEqualTo: true)
        .snapshots();
  }

  Future<String> createEvent(String fee, String photoURL, String place,
      String title, DateTime dateTime) async {
    try {
      DocumentReference docRef = _firestore.collection("events").doc();
      await docRef.set({
        'attendees': [],
        'date': Timestamp.fromDate(dateTime),
        'fee': fee,
        'photoUrl': photoURL,
        'place': place,
        'title': title,
        'id': docRef.id
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> createEventForApp(String fee, String photoURL, String place,
      String title, DateTime dateTime) async {
    try {
      DocumentReference docRef = _firestore.collection("events").doc();
      await docRef.set({
        'attendees': [],
        'date': Timestamp.fromDate(dateTime),
        'fee': fee,
        'photoUrl': photoURL,
        'place': place,
        'title': title,
        'id': docRef.id,
        'forApp': true
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> editEvent(String fee, String photoURL, String place,
      String title, DateTime dateTime, String id) async {
    try {
      await _firestore.collection('events').doc(id).update({
        'title': title,
        'place': place,
        'date': Timestamp.fromDate(dateTime),
        'photoUrl': photoURL,
        'fee': fee
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<String>> getIDofAttendees(String id) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("events")
          .where('id', isEqualTo: id)
          .limit(1)
          .get();
      return querySnapshot.docs.first.get('attendees');
    } catch (e) {
      return [];
    }
  }

  Future<String> deleteEvent(String id) async {
    try {
      await _firestore.collection("events").doc(id).delete();
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> toggleGoing(String eventId, bool going) async {
    try {
      String? userId = firebaseAuthAPI.getUserId();

      DocumentReference eventRef = _firestore.collection('events').doc(eventId);

      if (going) {
        await eventRef.update({
          'attendees': FieldValue.arrayUnion([userId])
        });
      } else {
        await eventRef.update({
          'attendees': FieldValue.arrayRemove([userId])
        });
      }
    } catch (e) {
      print('Error toggling going status: $e');
    }
  }
}
