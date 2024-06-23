import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAnnouncementAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        .where('committee', isEqualTo: 'General')
        .snapshots();
  }
}
