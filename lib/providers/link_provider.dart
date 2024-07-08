import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_link_api.dart';

class LinkProvider with ChangeNotifier {
  FirebaseLinkAPI firebaseLinkAPI = FirebaseLinkAPI();

  late Stream<QuerySnapshot> _publinksStream;
  Stream<QuerySnapshot> get publinks => _publinksStream;

  late Stream<QuerySnapshot> _postsStream;
  Stream<QuerySnapshot> get posts => _postsStream;

  LinkProvider() {
    fetchPubLinks();
    fetchPosts();
  }

  Stream<QuerySnapshot> fetchPubLinks() {
    _publinksStream = firebaseLinkAPI.getPubLinks();
    notifyListeners();
    return _publinksStream;
  }

  Stream<QuerySnapshot> fetchPosts() {
    _postsStream = firebaseLinkAPI.getPosts();
    notifyListeners();
    return _postsStream;
  }

  Future<String> createPubLink(String title, String url) async {
    return firebaseLinkAPI.createPubLink(title, url);
  }

  Future<String> createPost(String title, String caption, String url) async {
    return firebaseLinkAPI.createPost(title, caption, url);
  }

  Future<String> deleteLink(String id) async {
    return firebaseLinkAPI.deleteLink(id);
  }

  Future<String> editLink(String id, String title, String url) async {
    return firebaseLinkAPI.editLink(id, title, url);
  }
}
