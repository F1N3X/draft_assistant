import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';

class DraftView extends StatelessWidget {
  const DraftView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: draftAssistantAppBar('Live Draft'),
      body: const Center(
        child: Text('This is the Draft View'),
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(0)
    );
  }
}