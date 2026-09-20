import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';

class DraftView extends StatelessWidget {
  const DraftView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Live Draft'),
      body: Center(
        child: Text(
          'This is the Draft View',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 0),
    );
  }
}
