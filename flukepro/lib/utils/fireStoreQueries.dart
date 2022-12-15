import 'package:cloud_firestore/cloud_firestore.dart';
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
  DateTime now = DateTime.now();
  String formattedDate = intl.DateFormat('yyyy-MM-dd').format(now);
  QuerySnapshot Starter = await _firestore
      .collection('events')
      .where(
        'starterDate',
        isLessThanOrEqualTo: formattedDate,
      )
      .get();
  QuerySnapshot end = await _firestore
      .collection('events')
      .where(
        'endDate',
        isGreaterThanOrEqualTo: formattedDate,
      )
      .get();
  QuerySnapshot list = Starter;
  list.docs.remove(Starter);
  Starter.docs.forEach((startrelement) {
    end.docs.forEach((endelement) {
      if (startrelement.id == endelement.id) {
        list.docs.add(startrelement);
      }
    });
  });
  print(list.docs.length);
  return list.docs;
}

getAllEvents() async {
  QuerySnapshot AllEvents = await _firestore.collection('events').get();

  return AllEvents.docs;
}
