import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';
import 'package:draft_assistant/src/providers/draft_provider.dart';
import 'package:draft_assistant/src/providers/auth_provider.dart';
import 'package:draft_assistant/src/widgets/draft/team_side_selector.dart';
import 'package:draft_assistant/src/widgets/draft/ban_section.dart';
import 'package:draft_assistant/src/widgets/draft/champion_section.dart';
import 'package:draft_assistant/src/widgets/draft/draft_advice_sheet.dart';
import 'package:draft_assistant/src/services/objectbox_service.dart';

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

  Widget saveDraftButton(
    BuildContext context,
    WidgetRef ref,
    DraftState draft,
    User user,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: draft.isSavingDraft
            ? null
            : () async {
                final saved = await ref
                    .read(draftProvider.notifier)
                    .saveDraft(user.uid, ref.read(objectBoxProvider));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      saved
                          ? 'Draft sauvegardée sur Firestore et en local.'
                          : 'Impossible de sauvegarder la draft.',
                    ),
                  ),
                );
              },
        icon: draft.isSavingDraft
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.bookmark_border),
        label: Text(
          draft.isSavingDraft ? 'SAUVEGARDE...' : 'SAUVEGARDER LA DRAFT',
        ),
      ),
    );
  }

  Widget aiActions(BuildContext context, WidgetRef ref, DraftState draft) {
    final generateButton = FilledButton.icon(
      onPressed: draft.isGeneratingAdvice
          ? null
          : () async {
              final advice = await ref
                  .read(draftProvider.notifier)
                  .requestAiAdvice();
              if (!context.mounted) return;
              if (advice != null) {
                await showDraftAdviceSheet(context, advice);
                return;
              }
              final error = ref.read(draftProvider).aiError;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error ?? 'Impossible d\'obtenir un conseil.'),
                ),
              );
            },
      icon: draft.isGeneratingAdvice
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.smart_toy_outlined),
      label: Text(
        draft.isGeneratingAdvice
            ? 'ANALYSE EN COURS...'
            : draft.aiAdvice == null
            ? 'DEMANDER CONSEIL À L\'IA'
            : 'REGENERER',
      ),
    );

    if (draft.aiAdvice == null) {
      return SizedBox(width: double.infinity, child: generateButton);
    }

    return Row(
      children: [
        Expanded(child: generateButton),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: draft.isGeneratingAdvice
                ? null
                : () => showDraftAdviceSheet(context, draft.aiAdvice!),
            icon: const Icon(Icons.lightbulb_outline),
            label: const Text('RETOURS IA'),
          ),
        ),
      ],
    );
  }
}
