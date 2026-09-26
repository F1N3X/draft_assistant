import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:draft_assistant/src/providers/draft_provider.dart';
import 'package:draft_assistant/src/widgets/draft/draft_advice_sheet.dart';

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