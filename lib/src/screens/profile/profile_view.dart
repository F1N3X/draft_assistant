import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:draft_assistant/src/services/google_auth.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This is the Profile View',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              SignInButton(
                Buttons.google,
                onPressed: () => signInWithGoogle(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 2),
    );
  }
}
