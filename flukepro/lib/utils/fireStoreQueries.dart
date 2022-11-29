import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
// this function checks if uniqueName already exists
Future<bool> isUniqueID(
    String docName, String collectionName, String userID) async {
  QuerySnapshot query = await FirebaseFirestore.instance
      .collection('users')
      .doc(docName)
      .collection(collectionName)
      .where(FieldPath.documentId, isEqualTo: userID)
      .get();
  print('$docName doc is empty');
  print(query.docs.isEmpty);
  return query.docs.isEmpty;
}

//this function fetches Organizations requests
getMarker() async {
  final snapshot = await _firestore.collection('events').get();
  return snapshot.docs.map((doc) => doc.data());
}
