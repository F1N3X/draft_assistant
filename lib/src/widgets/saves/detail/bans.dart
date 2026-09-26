import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/saves/detail/champion_image.dart';

class BansCard extends StatelessWidget {
  final List<Map<String, dynamic>> blue;
  final List<Map<String, dynamic>> red;

  const BansCard({super.key, required this.blue, required this.red});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Champions bannis',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BanRow(label: 'BANS BLEU', color: Colors.blueAccent, items: blue),
          const SizedBox(height: 8),
          BanRow(label: 'BANS ROUGE', color: Colors.redAccent, items: red),
        ],
      ),
    );
  }
}

class BanRow extends StatelessWidget {
  final String label;
  final Color color;
  final List<Map<String, dynamic>> items;

  const BanRow({
    super.key,
    required this.label,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(5, (index) {
            final item = index < items.length ? items[index] : null;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 5),
                child: ChampionImage(
                  url: item?['imageUrl'] as String?,
                  name: item?['name'] as String?,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}