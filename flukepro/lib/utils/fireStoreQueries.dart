import 'package:cloud_firestore/cloud_firestore.dart';

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
  QuerySnapshot query = await _firestore
      .collection('events')
      .where('starterDate', isEqualTo: DateTime.now())
      .where('endDate', isGreaterThanOrEqualTo: DateTime.now())
      .get();

  return query.docs;
}
