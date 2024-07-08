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

  Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection('links')
        .where('category', isEqualTo: "post")
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
}
