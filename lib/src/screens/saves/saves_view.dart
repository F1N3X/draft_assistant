import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';

class SavesView extends StatelessWidget {
  const SavesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Draft sauvegardées'),
      body: const Center(
        child: Text('This is the Saves View'),
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 1)
    );
  }
}