import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Profile'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('This is the Profile View'),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance
                  .authStateChanges()
                  .listen((User? user) {
                    if (user == null) {
                      print('User is currently signed out!');
                    } else {
                      print('User is signed in!');
                    }
                  }
                );
              },
              child: const Text('Sign Out'),
            )
        ],)
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 2)
    );
  }
}