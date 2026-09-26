import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUser(String uid) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).set(
    <String, dynamic>{},
    SetOptions(merge: true),
  );
}

Future<int> getSavedDraftCount(String uid) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();
  final draftIds = snapshot.data()?['draftIds'];

  if (draftIds is List && draftIds.isNotEmpty) return draftIds.length;

  final draftsSnapshot = await FirebaseFirestore.instance
      .collection('drafts')
      .where('userId', isEqualTo: uid)
      .get();
  return draftsSnapshot.docs.length;
}
