import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:draft_assistant/src/services/draft_persistence_service.dart';
import 'package:draft_assistant/src/services/objectbox_service.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';

class SavedDraftDetailView extends ConsumerWidget {
  final String draftId;

  const SavedDraftDetailView({super.key, required this.draftId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Connexion requise.')));
    }

    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Détail de la draft'),
      body: FutureBuilder<SavedDraftRecord?>(
        future: loadSavedDraft(
          uid: user.uid,
          id: draftId,
          objectBox: ref.read(objectBoxProvider),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final draft = snapshot.data;
          if (draft == null) {
            return const Center(child: Text('Cette draft est introuvable.'));
          }
          return DetailContent(draft: draft);
        },
      ),
    );
  }
}

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

class Advice extends StatelessWidget {
  final Map<String, dynamic> advice;

  const Advice({super.key, required this.advice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final winRate = (advice['winRate'] ?? advice['win_rate']) as num?;
    final strengths = strings(advice['strengths']);
    final weaknesses = strings(advice['weaknesses']);
    final winCondition = (advice['winCondition'] ?? advice['win_condition'])
        ?.toString();
    return Container(
      padding: const EdgeInsets.all(10),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, size: 18),
              const SizedBox(width: 6),
              Text('Analyse finale', style: theme.textTheme.titleMedium),
            ],
          ),
          if (advice['summary'] is String &&
              (advice['summary'] as String).isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(advice['summary'] as String, maxLines: 2),
          ],
          AdviceLine(
            label: 'POINTS FORTS',
            values: strengths,
            color: Colors.greenAccent,
            icon: Icons.check_box_outlined,
          ),
          AdviceLine(
            label: 'MENACES',
            values: weaknesses,
            color: Colors.redAccent,
            icon: Icons.warning_amber_outlined,
          ),
          AdviceLine(
            label: 'CONDITION DE VICTOIRE',
            values: winCondition == null ? const [] : [winCondition],
            color: Colors.blueAccent,
            icon: Icons.flag_outlined,
          ),
          if (winRate != null) WinRateBar(value: winRate.toDouble()),
        ],
      ),
    );
  }

  List<String> strings(Object? value) =>
      value is List ? value.whereType<String>().toList() : const [];
}

class AdviceLine extends StatelessWidget {
  final String label;
  final List<String> values;
  final Color color;
  final IconData icon;

  const AdviceLine({
    super.key,
    required this.label,
    required this.values,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: color, fontWeight: FontWeight.w800),
                ),
                ...values.map((value) => Text(value)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WinRateBar extends StatelessWidget {
  final double value;

  const WinRateBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 100).toDouble();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROBABILITÉ THÉORIQUE',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Row(
            children: [
              Text(
                '${value.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: Colors.greenAccent),
              ),
              const Spacer(),
              SizedBox(
                width: 82,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: clamped / 100,
                    minHeight: 8,
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.7),
                    valueColor: const AlwaysStoppedAnimation(
                      Colors.greenAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
