import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';
import 'package:draft_assistant/src/providers/draft_provider.dart';
import 'package:draft_assistant/src/widgets/draft_widgets.dart';

class DraftView extends StatelessWidget {
  const DraftView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Live Draft'),
      body: Consumer(
        builder: (context, ref, child) {
          final draft = ref.watch(draftProvider);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'BANS',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  banSection(
                    context,
                    ref,
                    draft,
                    slots: const [
                      [
                        DraftSlot.blueBan1,
                        DraftSlot.blueBan2,
                        DraftSlot.blueBan3,
                        DraftSlot.blueBan4,
                        DraftSlot.blueBan5,
                      ],
                      [
                        DraftSlot.redBan1,
                        DraftSlot.redBan2,
                        DraftSlot.redBan3,
                        DraftSlot.redBan4,
                        DraftSlot.redBan5,
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 0),
    );
  }
}
