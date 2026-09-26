import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';
import 'package:draft_assistant/src/widgets/profile/signed_out_profile.dart';
import 'package:draft_assistant/src/widgets/profile/signed_in_profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Profile'),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data;
          return user == null
              ? const SignedOutProfile()
              : SignedInProfile(user: user);
        },
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 2),
    );
  }
}
