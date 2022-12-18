import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart%20';
import 'package:intl/intl.dart' as intl;

final _firestore = FirebaseFirestore.instance;
// this function checks if uniqueName already exists
Future<bool> isUniqueID(String userID) async {
  QuerySnapshot query = await FirebaseFirestore.instance
      .collection('users')
      .where(FieldPath.documentId, isEqualTo: userID)
      .get();

  return query.docs.isEmpty;
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

getOngoing() async {
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
  QuerySnapshot ongoing = await _firestore.collection('events').get()
    ..docs.where((event) {
      DateTime start =
          DateTime.fromMicrosecondsSinceEpoch(event['starterDate']);
      DateTime end = DateTime.fromMicrosecondsSinceEpoch(event['endDate']);
      print(start);
      print(end);
      return event['starterDate'].isBefore(DateTime.now()) &&
              event['endDate'].isBefore(DateTime.now())
          // ||
          // end.compareTo(DateTime.now()) == 0 ||
          // start.compareTo(DateTime.now()) == 0
          ;
    });
  return ongoing.docs;
}

getAllEvents() async {
  QuerySnapshot AllEvents = await _firestore.collection('events').get();

  return AllEvents.docs;
}
