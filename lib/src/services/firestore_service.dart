import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUser(String uid) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).set(
    <String, dynamic>{'draftIds': <String>[]},
    SetOptions(merge: true),
  );
}
