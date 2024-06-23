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
