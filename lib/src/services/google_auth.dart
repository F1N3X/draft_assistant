import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> ensureIintialized () {
  return GoogleSignInPlatform.instance.init(const InitParameters());
}

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    await ensureIintialized();

    final AuthenticationResults result = await GoogleSignInPlatform.instance.authenticate(const AuthenticateParameters()); 

    final String? idToken = result.authenticationTokens.idToken ;

    if (idToken != null) {
      final OAuthCredential credential = GoogleAuthProvider.credential(idToken: idToken);

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion réussie avec Google : ${firebaseUser.displayName}')),
        );
      }
    }

  } on GoogleSignInException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la récupération du token Google : $e')),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la connexion avec Firebase: $e')),
    );
  }
}