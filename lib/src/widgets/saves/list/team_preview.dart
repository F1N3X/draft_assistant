import 'package:draft_assistant/src/services/draft_persistence_service.dart';
import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/saves/list/champion_image.dart';

class TeamPreview extends StatelessWidget {
  final SavedDraftRecord draft;

  const TeamPreview({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'COMPO',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 5),
          TeamRow(
            label: 'BLUE',
            color: Colors.blueAccent,
            items: items(draft, 'blueChampion'),
          ),
          const SizedBox(height: 6),
          TeamRow(
            label: 'RED',
            color: Colors.redAccent,
            items: items(draft, 'redChampion'),
          ),
          const SizedBox(height: 8),
          BansPreview(draft: draft),
        ],
      ),
    );
  }

  List<Map<String, dynamic>?> items(SavedDraftRecord draft, String prefix) {
    return List.generate(5, (index) {
      final item = draft.selections['$prefix${index + 1}'];
      if (item is! Map) return null;
      return item.map((key, value) => MapEntry(key.toString(), value));
    });
  }
}

class TeamRow extends StatelessWidget {
  final String label;
  final Color color;
  final List<Map<String, dynamic>?> items;

  const TeamRow({
    super.key,
    required this.label,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 38,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Row(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: ChampionImage(
                      url: item?['imageUrl'] as String?,
                      name: item?['name'] as String?,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class BansPreview extends StatelessWidget {
  final SavedDraftRecord draft;

  const BansPreview({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline
                .withValues(alpha: 0.18),
          ),
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'BANS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 5),
          TeamRow(
            label: 'BLUE',
            color: Colors.blueAccent,
            items: items('blueBan'),
          ),
          const SizedBox(height: 6),
          TeamRow(
            label: 'RED',
            color: Colors.redAccent,
            items: items('redBan'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>?> items(String prefix) {
    return List.generate(5, (index) {
      final item = draft.selections['$prefix${index + 1}'];
      if (item is! Map) return null;
      return item.map((key, value) => MapEntry(key.toString(), value));
    });
  }
}