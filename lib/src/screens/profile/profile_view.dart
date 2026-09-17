import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Profile'),
      body: const Center(
        child: Text('This is the Profile View'),
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 2)
    );
  }
}