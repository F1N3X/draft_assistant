import 'package:flutter/material.dart';

class ChampionImage extends StatelessWidget {
  final String? url;
  final String? name;

  const ChampionImage({super.key, this.url, this.name});

  String get initials =>
      (name ?? '').trim().characters.take(3).join().toUpperCase();

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = url == null || url!.isEmpty;
    final fallback = Center(
      child: Text(
        initials,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
    final image = isPlaceholder
        ? fallback
        : Image.network(
            url!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => fallback,
          );
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(4),
        border: isPlaceholder
            ? Border.all(color: Theme.of(context).colorScheme.outline)
            : null,
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: image,
    );
  }
}