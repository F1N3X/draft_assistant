import 'package:flutter/material.dart';

class ChampionImage extends StatelessWidget {
  final String? url;
  final String? name;

  const ChampionImage({super.key, this.url, this.name});

  String get initials =>
      (name ?? '').trim().characters.take(3).join().toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(3),
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null || url!.isEmpty
          ? FallbackLabel(text: initials)
          : Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => FallbackLabel(text: initials),
            ),
    );
  }
}

class FallbackLabel extends StatelessWidget {
  final String text;

  const FallbackLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}