import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart%20';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import 'SigningProvider.dart';

final _firestore = FirebaseFirestore.instance;
// this function checks if uniqueName already exists
Future<bool> isUniqueID(String userID) async {
  QuerySnapshot query = await FirebaseFirestore.instance
      .collection('users')
      .where(FieldPath.documentId, isEqualTo: userID)
      .get();

  return query.docs.isEmpty;
}

Future<QuerySnapshot<Map<String, dynamic>>> getLikedEvents(context) async {
  return await FirebaseFirestore.instance
      .collection('events')
      .where('likes.${Provider.of<siggning>(context).loggedUser!.uid}',
          isEqualTo: true)
      .get();
}

Future<bool> EmailExists(String email) async {
  QuerySnapshot query = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();
  return query.docs.isNotEmpty;
}

//this function fetches Organizations requests
getMarker() async {
  final snapshot = await _firestore.collection('events').get();
  return snapshot.docs.map((doc) => doc.data());
}

Future<Map<String, dynamic>?> getTempUser(userID) async {
  DocumentSnapshot<Map<String, dynamic>> userInfo =
      await _firestore.collection('users').doc(userID).get();

  Map<String, dynamic>? userInfoDoc = userInfo.data();
  return userInfoDoc;
}

getInterstsBasedEvents(userId, context) {
  //make sure that there is the same interest in the event and the user if it didnt work filter in the app
  var info = getTempUser(userId);
  var interests = Provider.of<siggning>(context).userInfoDocument;
  return FirebaseFirestore.instance
      .collection('events')
      .where('field', arrayContains: interests)
      .snapshots();
}

getOngoing() {
  // Timestamp now = Timestamp.now();
  //
  // QuerySnapshot Starter = await _firestore
  //     .collection('events')
  //     .where(
  //       'starterDate',
  //       isLessThanOrEqualTo: now,
  //     )
  //     .get();
  // QuerySnapshot end = await _firestore
  //     .collection('events')
  //     .where(
  //       'endDate',
  //       isGreaterThanOrEqualTo: now,
  //     )
  //     .get();
  // QuerySnapshot list = Starter;
  // list.docs.remove(Starter);
  // Starter.docs.forEach((startrelement) {
  //   end.docs.forEach((endelement) {
  //     if (startrelement.id == endelement.id) {
  //       list.docs.add(startrelement);
  //     }
  //   });
  // });
  // print(list.docs.length);
  // return list.docs;
  var events = _firestore.collection('events').snapshots()
      //     .listen((event) {
      //   for (var doc in event.docs) {
      //     DateTime start =
      //         DateTime.fromMicrosecondsSinceEpoch(doc.data()['starterDate']);
      //     DateTime end = DateTime.fromMicrosecondsSinceEpoch(doc.data()['endDate']);
      //     print(start);
      //     print(end);
      //     if (start.isBefore(DateTime.now()) && end.isAfter(DateTime.now()))
      //       events.add(doc);
      //     return doc;
      //   }
      //   // ||
      //   // end.compareTo(DateTime.now()) == 0 ||
      //   // start.compareTo(DateTime.now()) == 0
      //   ;
      // }
      //)
      ;
  return events;
}

Stream<QuerySnapshot<Map<String, dynamic>>> getUserReegiteredEvents(
    String userId) {
  final AllEvents = _firestore
      .collection('users')
      .doc(userId)
      .collection('tickets')
      .snapshots();

  return AllEvents;
}

getCreatorEvent(userID) {
  final AllEvents = _firestore
      .collection('events')
      .where('creatorId', isEqualTo: userID)
      .snapshots();

  return AllEvents;
}

getOrganizersEvent(context, OrganizerId) async {
  print(Provider.of<siggning>(context, listen: false).loggedUser!.uid.trim());
  QuerySnapshot AllEvents = await FirebaseFirestore.instance
      .collection('events')
      .where('creatorID', isEqualTo: OrganizerId.trim())
      .where('eventVisibility', isEqualTo: true)
      .orderBy('creationDate', descending: true)
      .get();
  return AllEvents.docs;
}

getOrganizersVisisbleEvent(context) async {
  print(Provider.of<siggning>(context, listen: false).loggedUser!.uid.trim());
  QuerySnapshot AllEvents = await FirebaseFirestore.instance
      .collection('events')
      .where('creatorID',
          isEqualTo: Provider.of<siggning>(context, listen: false)
              .loggedUser!
              .uid
              .trim())
      .orderBy('creationDate', descending: true)
      .get();
  return AllEvents.docs;
}

getOrganizersEventSnapshot(context) {
  print(Provider.of<siggning>(context, listen: false).loggedUser!.uid.trim());
  Stream<QuerySnapshot> AllEvents = FirebaseFirestore.instance
      .collection('events')
      .where('creatorID',
          isEqualTo: Provider.of<siggning>(context, listen: false)
              .loggedUser!
              .uid
              .trim())
      .snapshots();
  return AllEvents;
}

getOrganizersEventForAgendaSnapshot(context) {
  print(Provider.of<siggning>(context, listen: false).loggedUser!.uid.trim());
  Stream<QuerySnapshot> AllEvents = FirebaseFirestore.instance
      .collection('events')
      .where('creatorID',
          isEqualTo: Provider.of<siggning>(context, listen: false)
              .loggedUser!
              .uid
              .trim())
      .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
      .snapshots();
  return AllEvents;
}

Future<DocumentSnapshot<Map<String, dynamic>>> getSessionInfo(
    sessionID, eventID) async {
  var sessionInfo = await FirebaseFirestore.instance
      .collection('events')
      .doc(eventID)
      .collection('agenda')
      .doc(sessionID)
      .get();
  return sessionInfo;
}

Future<int?> gettingNumberOfEventVisitors(eventId) async {
  var snapshot = await _firestore
      .collection('events')
      .doc(eventId)
      .collection('visitors')
      .get();
  return await snapshot.docs?.length;
}
