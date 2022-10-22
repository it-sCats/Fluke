import 'package:cloud_firestore/cloud_firestore.dart';

// this function checks if uniqueName already exists
Future<bool> isDuplicateUniqueID(String collectionName,String userID) async {
  QuerySnapshot query = await FirebaseFirestore.instance
      .collection(collectionName)
      .where('userID', isEqualTo: userID)
      .get();
  return query.docs.isNotEmpty;
}