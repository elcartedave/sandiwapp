import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseLinkAPI {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> createPubLink(String title, String url) async {
    try {
      DocumentReference docRef = _firestore.collection("links").doc();
      await docRef.set({
        'id': docRef.id,
        'title': title,
        'url': url,
        'caption': '',
        'date': Timestamp.fromDate(DateTime.now()),
        'category': "publink"
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Stream<QuerySnapshot> getPubLinks() {
    return _firestore
        .collection('links')
        .where('category', isEqualTo: "publink")
        .snapshots();
  }

  Stream<DocumentSnapshot> getLuponTracker(String lupon) {
    return _firestore
        .collection('links')
        .where('category', isEqualTo: lupon)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first;
      } else {
        throw Exception("No documents found");
      }
    });
  }

  Future<String> createPost(String title, String caption, String url) async {
    try {
      DocumentReference docRef = _firestore.collection("links").doc();
      await docRef.set({
        'id': docRef.id,
        'title': title,
        'url': url,
        'caption': caption,
        'date': Timestamp.fromDate(DateTime.now()),
        'category': "post"
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> createMinutes(String title, String url) async {
    try {
      DocumentReference docRef = _firestore.collection("links").doc();
      await docRef.set({
        'id': docRef.id,
        'title': title,
        'url': url,
        'date': Timestamp.fromDate(DateTime.now()),
        'category': "minutes"
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> createMinutesQuill(
      String title, String content, String format) async {
    try {
      DocumentReference docRef = _firestore.collection("links").doc();
      await docRef.set({
        'id': docRef.id,
        'title': title,
        'url': '',
        'caption': content,
        'format': format,
        'date': Timestamp.fromDate(DateTime.now()),
        'category': "minutes"
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> createTracker(String url, String lupon) async {
    try {
      DocumentReference docRef = _firestore.collection("links").doc();
      await docRef.set({
        'id': docRef.id,
        'title': "Tracker",
        'url': url,
        'caption': '',
        'date': Timestamp.fromDate(DateTime.now()),
        'category': lupon,
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection('links')
        .where('category', isEqualTo: "post")
        .snapshots();
  }

  Stream<QuerySnapshot> getMinutes() {
    return _firestore
        .collection('links')
        .where('category', isEqualTo: "minutes")
        .snapshots();
  }

  Future<String> deleteLink(String id) async {
    try {
      await _firestore.collection('links').doc(id).delete();
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> editLink(String id, String title, String url) async {
    try {
      await _firestore.collection('links').doc(id).update({
        'id': id,
        'title': title,
        'url': url,
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> editMinutesQuill(
      String id, String title, String content, String format) async {
    try {
      await _firestore.collection('links').doc(id).update({
        'id': id,
        'title': title,
        'url': '',
        'caption': content,
        'format': format,
      });
      return '';
    } catch (e) {
      return e.toString();
    }
  }
}
