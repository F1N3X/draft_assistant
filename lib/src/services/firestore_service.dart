import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUser(String uid) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).set(
    <String, dynamic>{'draftIds': <String>[]},
    SetOptions(merge: true),
  );
}

Future<int> getSavedDraftCount(String uid) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();
  final draftIds = snapshot.data()?['draftIds'];

  return draftIds is List ? draftIds.length : 0;
}
