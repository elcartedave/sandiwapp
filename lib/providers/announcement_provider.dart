import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandiwapp/api/firebase_announcement_api.dart';

class AnnouncementProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _genAnnouncementsStream;
  Stream<QuerySnapshot> get genAnnouncements => _genAnnouncementsStream;

  late Stream<QuerySnapshot> _edukAnnouncementsStream;
  Stream<QuerySnapshot> get edukAnnouncements => _edukAnnouncementsStream;

  late Stream<QuerySnapshot> _finAnnouncementsStream;
  Stream<QuerySnapshot> get finAnnouncements => _finAnnouncementsStream;

  late Stream<QuerySnapshot> _pubAnnouncementsStream;
  Stream<QuerySnapshot> get pubAnnouncements => _pubAnnouncementsStream;

  late Stream<QuerySnapshot> _exteAnnouncementsStream;
  Stream<QuerySnapshot> get exteAnnouncements => _exteAnnouncementsStream;

  late Stream<QuerySnapshot> _memAnnouncementsStream;
  Stream<QuerySnapshot> get memAnnouncements => _memAnnouncementsStream;

  FirebaseAnnouncementAPI firebaseService = FirebaseAnnouncementAPI();

  AnnouncementProvider() {
    fetchGenAnnouncements();
    fetchEdukAnnouncements();
    fetchFinAnnouncements();
    fetchExteAnnouncements();
    fetchMemAnnouncements();
    fetchPubAnnouncements();
  }

  Stream<QuerySnapshot> fetchGenAnnouncements() {
    _genAnnouncementsStream = firebaseService.getGeneralAnnouncements();
    notifyListeners();
    return _genAnnouncementsStream;
  }

  Stream<QuerySnapshot> fetchEdukAnnouncements() {
    _edukAnnouncementsStream = firebaseService.getEdukAnnouncements();
    notifyListeners();
    return _edukAnnouncementsStream;
  }

  Stream<QuerySnapshot> fetchFinAnnouncements() {
    _finAnnouncementsStream = firebaseService.getFinAnnouncements();
    notifyListeners();
    return _finAnnouncementsStream;
  }

  Stream<QuerySnapshot> fetchExteAnnouncements() {
    _exteAnnouncementsStream = firebaseService.getExteAnnouncements();
    notifyListeners();
    return _exteAnnouncementsStream;
  }

  Stream<QuerySnapshot> fetchPubAnnouncements() {
    _genAnnouncementsStream = firebaseService.getGeneralAnnouncements();
    notifyListeners();
    return _genAnnouncementsStream;
  }

  Stream<QuerySnapshot> fetchMemAnnouncements() {
    _memAnnouncementsStream = firebaseService.getMemAnnouncements();
    notifyListeners();
    return _memAnnouncementsStream;
  }

  Stream<QuerySnapshot> fetchAllAnnouncements() {
    return firebaseService.getAllAnnouncements();
  }

  Stream<DocumentSnapshot> fetchSpecificAnnouncement(String id) {
    return firebaseService.getSpecificAnnouncement(id);
  }
}
