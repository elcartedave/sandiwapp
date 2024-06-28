import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandiwapp/models/activityModel.dart';

class FirebaseActivityAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> createActivity(Activity activity) async {
    try {
      DocumentReference docRef = _firestore.collection("activities").doc();

      // Set the document data with the auto-generated ID
      await docRef.set({
        'id': docRef.id,
        'title': activity.title,
        'content': activity.content,
        'lupon': activity.lupon,
        'date': Timestamp.fromDate(activity.date)
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Stream<QuerySnapshot> getActivities(String lupon) {
    return _firestore
        .collection('activities')
        .where('lupon', isEqualTo: lupon)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllActivities() {
    return _firestore
        .collection('activities')
        .where('lupon', isEqualTo: 'General')
        .snapshots();
  }
}
