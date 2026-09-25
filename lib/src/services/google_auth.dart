import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:draft_assistant/src/services/firestore_service.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    const String serverClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');

    if (serverClientId.isEmpty) {
      throw Exception('La variable GOOGLE_CLIENT_ID est introuvable.');
    }

    await GoogleSignIn.instance.initialize(serverClientId: serverClientId);

    final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
        .authenticate();

    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    final firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      await addUser(firebaseUser.uid);
    }

    if (firebaseUser != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Connexion avec Google réussie : ${firebaseUser.displayName}',
          ),
        ),
      );
    }
  } on GoogleSignInException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur lors de la récupération du token Google : $e'),
      ),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la connexion avec Firebase: $e')),
    );
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
