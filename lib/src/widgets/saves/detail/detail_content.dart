import 'package:flutter/material.dart';
import 'package:draft_assistant/src/services/draft_persistence_service.dart';
import 'package:draft_assistant/src/widgets/saves/detail/composition.dart';
import 'package:draft_assistant/src/widgets/saves/detail/bans.dart';
import 'package:draft_assistant/src/widgets/saves/detail/advice.dart';

class DetailContent extends StatelessWidget {
  final SavedDraftRecord draft;

  const DetailContent({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final advice = draft.aiAdvice;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          draft.updatedAt.toString().split('.').first,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Mon équipe : ${draft.myTeam == 'blue' ? 'Bleu' : 'Rouge'}',
          style: theme.textTheme.labelMedium?.copyWith(
            color: draft.myTeam == 'blue'
                ? Colors.blueAccent
                : Colors.redAccent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Composition(
          blue: champions('blueChampion'),
          red: champions('redChampion'),
        ),
        const SizedBox(height: 12),
        BansCard(blue: champions('blueBan'), red: champions('redBan')),
        if (advice.isNotEmpty) ...[
          const SizedBox(height: 14),
          Advice(advice: advice),
        ],
      ],
    );
  }

  List<Map<String, dynamic>> champions(String prefix) {
    return draft.selections.entries
        .where((entry) => entry.key.startsWith(prefix))
        .map((entry) => entry.value)
        .whereType<Map>()
        .map(
          (item) => item.map((key, value) => MapEntry(key.toString(), value)),
        )
        .toList();
  }
}