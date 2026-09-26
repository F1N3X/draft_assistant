import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';
import 'package:draft_assistant/src/providers/draft_provider.dart';
import 'package:draft_assistant/src/providers/auth_provider.dart';
import 'package:draft_assistant/src/widgets/draft/team_side_selector.dart';
import 'package:draft_assistant/src/widgets/draft/ban_section.dart';
import 'package:draft_assistant/src/widgets/draft/champion_section.dart';
import 'package:draft_assistant/src/widgets/draft/ai_actions.dart';
import 'package:draft_assistant/src/widgets/draft/save_draft_button.dart';

class DraftView extends StatelessWidget {
  const DraftView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Live Draft'),
      body: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authStateProvider);
          final user = authState.value;

          return authState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => const Center(
              child: Text('Impossible de vérifier la connexion.'),
            ),
            data: (_) {
              final draft = ref.watch(draftProvider);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      teamSideSelector(context, ref, draft),
                      const SizedBox(height: 12),
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
                      const SizedBox(height: 20),
                      championSection(context, ref, draft),
                      const SizedBox(height: 20),
                      aiActions(context, ref, draft),
                      if (user != null) ...[
                        const SizedBox(height: 12),
                        saveDraftButton(context, ref, draft, user),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 0),
    );
  }
}
