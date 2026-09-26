import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/saves/detail/champion_image.dart';

class Composition extends StatelessWidget {
  final List<Map<String, dynamic>> blue;
  final List<Map<String, dynamic>> red;

  const Composition({super.key, required this.blue, required this.red});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: theme.colorScheme.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SideComposition(
              title: 'Blue Side',
              color: Colors.blueAccent,
              items: blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SideComposition(
              title: 'Red Side',
              color: Colors.redAccent,
              items: red,
              reverse: true,
            ),
          ),
        ],
      ),
    );
  }
}

class SideComposition extends StatelessWidget {
  final String title;
  final Color color;
  final List<Map<String, dynamic>> items;
  final bool reverse;

  const SideComposition({
    super.key,
    required this.title,
    required this.color,
    required this.items,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: reverse
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: reverse
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!reverse) Container(width: 6, height: 14, color: color),
            if (!reverse) const SizedBox(width: 5),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(color: color, fontWeight: FontWeight.w700),
            ),
            if (reverse) const SizedBox(width: 5),
            if (reverse) Container(width: 6, height: 14, color: color),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(5, (index) {
          final item = index < items.length ? items[index] : null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ChampionLine(item: item, reverse: reverse),
          );
        }),
      ],
    );
  }
}

class ChampionLine extends StatelessWidget {
  final Map<String, dynamic>? item;
  final bool reverse;

  const ChampionLine({super.key, required this.item, this.reverse = false});

  @override
  Widget build(BuildContext context) {
    final name = item?['name'] as String?;
    final imageUrl = item?['imageUrl'] as String?;
    final image = ChampionImage(url: imageUrl, name: name);
    final label = Expanded(
      child: name == null || name.isEmpty
          ? const SizedBox.shrink()
          : Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: reverse ? TextAlign.right : TextAlign.left,
              style: Theme.of(context).textTheme.labelMedium,
            ),
    );

    return Row(
      children: reverse
          ? [label, const SizedBox(width: 6), image]
          : [image, const SizedBox(width: 6), label],
    );
  }
}