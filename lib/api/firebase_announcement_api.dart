import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAnnouncementAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createAnnouncement(
      String title, String content, String committee) async {
    try {
      DocumentReference docRef = _firestore.collection("announcements").doc();

      // Set the document data with the auto-generated ID
      await docRef.set({
        'id': docRef.id,
        'title': title,
        'content': content,
        'committee': committee,
        'date': Timestamp.fromDate(DateTime.now())
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deleteAnnouncement(String id) async {
    try {
      await _firestore.collection("announcements").doc(id).delete();
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> editAnnouncement(
      String title, String content, String id) async {
    try {
      await _firestore.collection('announcements').doc(id).update({
        'title': title,
        'content': content,
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Stream<QuerySnapshot> getAllAnnouncements() {
    //gets all todo instances of a specific user
    return _firestore.collection("announcements").snapshots();
  }

  Stream<DocumentSnapshot> getSpecificAnnouncement(String id) {
    // obtain a stream of specific user document
    return _firestore.collection("announcements").doc(id).snapshots();
  }

  Stream<QuerySnapshot> getGeneralAnnouncements() {
    return _firestore
        .collection('announcements')
        .where('committee', isEqualTo: 'General')
        .snapshots();
  }

  Stream<QuerySnapshot> getEdukAnnouncements() {
    return _firestore
        .collection('announcements')
        .where('committee', isEqualTo: 'Eduk')
        .snapshots();
  }

  Stream<QuerySnapshot> getFinAnnouncements() {
    return _firestore
        .collection('announcements')
        .where('committee', isEqualTo: 'Fin')
        .snapshots();
  }

  Stream<QuerySnapshot> getMemAnnouncements() {
    return _firestore
        .collection('announcements')
        .where('committee', isEqualTo: 'Mem')
        .snapshots();
  }

  Stream<QuerySnapshot> getPubAnnouncements() {
    return _firestore
        .collection('announcements')
        .where('committee', isEqualTo: 'Pub')
        .snapshots();
  }

  Stream<QuerySnapshot> getExteAnnouncements() {
    return _firestore
        .collection('announcements')
        .where('committee', isEqualTo: 'Exte')
        .snapshots();
  }
}
