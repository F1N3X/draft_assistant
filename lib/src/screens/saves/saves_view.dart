import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';
import 'package:draft_assistant/src/services/draft_persistence_service.dart';
import 'package:draft_assistant/src/services/objectbox_service.dart';

class SavesView extends StatelessWidget {
  const SavesView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Draft sauvegardées'),
      body: Consumer(
        builder: (context, ref, child) {
          return user == null
              ? const Message(text: 'Connecte-toi pour retrouver tes drafts.')
              : FutureBuilder<List<SavedDraftRecord>>(
                  future: loadSavedDrafts(
                    uid: user.uid,
                    objectBox: ref.read(objectBoxProvider),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Message(
                        text: 'Impossible de charger les drafts.',
                      );
                    }
                    final drafts = snapshot.data ?? const <SavedDraftRecord>[];
                    if (drafts.isEmpty) {
                      return const Message(text: 'Aucune draft sauvegardée.');
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: drafts.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          DraftCard(draft: drafts[index]),
                    );
                  },
                );
        },
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 1),
    );
  }
}

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

class Message extends StatelessWidget {
  final String text;

  const Message({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}
