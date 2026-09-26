import 'package:draft_assistant/src/services/draft_persistence_service.dart';
import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/saves/list/team_preview.dart';
import 'package:go_router/go_router.dart';

class DraftCard extends StatelessWidget {
  final SavedDraftRecord draft;

  const DraftCard({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final winRate =
        (draft.aiAdvice['winRate'] ?? draft.aiAdvice['win_rate']) as num?;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  draft.updatedAt.toString().split('.').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),
              if (winRate != null) WinRate(value: winRate.toDouble()),
            ],
          ),
          const SizedBox(height: 8),
          TeamPreview(draft: draft),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () => context.push('/saves/${draft.id}'),
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: const Text('Détails'),
            style: FilledButton.styleFrom(
              backgroundColor: scheme.secondary,
              foregroundColor: scheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WinRate extends StatelessWidget {
  final double value;

  const WinRate({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final favorable = value >= 50;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      color: favorable ? Colors.teal : Colors.red,
      child: Text(
        '${value.toStringAsFixed(1)}% ${favorable ? 'WR' : 'Défavorable'}',
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}