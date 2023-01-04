import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/components/session.dart';
import 'package:flutter/material.dart';

class eventInfoHolder extends ChangeNotifier {
  List<Session> _sessions = [];
  List<Session> get sessios => _sessions;

  void addSession(Session session) {
    _sessions.add(session);
    notifyListeners();
  }

  Map<String, dynamic>? docOfEvent;
  Timestamp? starterDate;
  Timestamp? endDate;
  Future<Map<String, dynamic>?> getEventInfoForTimetable(
      eventID, context) async {
    final eventdoc = await FirebaseFirestore.instance
        .collection('events')
        .doc(eventID)
        .get();
    docOfEvent = eventdoc.data();
    starterDate = docOfEvent!['starterDate'];
    endDate = docOfEvent!['endDate'];
    print('endDate from provider');
    print(endDate);
    notifyListeners();

    return eventdoc.data();
  }
}
