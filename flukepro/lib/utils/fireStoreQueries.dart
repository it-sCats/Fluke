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

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getCommentsOnEvent(
    eventID) async {
  QuerySnapshot<Map<String, dynamic>> comments = await FirebaseFirestore
      .instance
      .collection('comments')
      .doc(eventID)
      .collection('comment')
      .get();

  return comments.docs;
  ;
}

isVistor(userID, eventID) {
  final visitor = FirebaseFirestore.instance
      .collection('events')
      .doc(eventID.toString().trim())
      .collection('visitors')
      .where('userID', isEqualTo: userID);
}

getInterstsBasedEvents(userId, context) {
  //make sure that there is the same interest in the event and the user if it didnt work filter in the app
  var info = getTempUser(userId);
  var interests = Provider.of<siggning>(context).userInfoDocument!['interests'];
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

//تجيب التيكيتس الخاصين بيوزر معين
Stream<QuerySnapshot<Map<String, dynamic>>> getUserReegiteredEvents(
    String userId) {
  final AllEvents = _firestore
      .collection('users')
      .doc(userId)
      .collection('tickets')
      .snapshots();

  return AllEvents;
}

Stream<QuerySnapshot<Map<String, dynamic>>> getPostComments(String eventID) {
  final AllEvents = _firestore
      .collection('comments')
      .doc(eventID)
      .collection('comment')
      .orderBy('creationDate', descending: true)
      .snapshots();

  return AllEvents;
}

//تجيب الايفينتس الخاصيين بمنظم معين
getCreatorEvent(userID) {
  final AllEvents = _firestore
      .collection('events')
      .where('creatorId', isEqualTo: userID)
      .snapshots();

  return AllEvents;
}

setSearchParam(String caseNumber) {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < caseNumber.length; i++) {
    temp = temp + caseNumber[i];
    caseSearchList.add(temp);
  }
  return caseSearchList;
}

//تجيب المشاركين في الحدث الي بنعطوه الاي دي متاعه
Future<QuerySnapshot> getParticipantOfEvent(eventID) async {
  QuerySnapshot parti = await _firestore
      .collection('events')
      .doc(eventID)
      .collection('participants')
      .get();
  return parti;
}

Future<QuerySnapshot> getvisitorsOfEvent(eventID) async {
  QuerySnapshot parti = await _firestore
      .collection('events')
      .doc(eventID)
      .collection('visitors')
      .get();
  return parti;
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

getParticipantsEvents(participantsId) async {
  QuerySnapshot AllEvents = await FirebaseFirestore.instance
      .collectionGroup('participants')
      .where('id', isEqualTo: participantsId.toString().trim())
      .get();
  List EventIds = [];
  AllEvents.docs.forEach((element) {
    EventIds.add(element['eventID']);
  });
  QuerySnapshot eve = await FirebaseFirestore.instance
      .collection('events')
      .where('id', whereIn: EventIds)
      .get();
  print(EventIds);

  return eve.docs;
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
