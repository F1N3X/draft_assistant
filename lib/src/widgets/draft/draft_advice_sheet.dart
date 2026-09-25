import 'package:flutter/material.dart';
import '../../services/ai_service.dart';

Future<void> showDraftAdviceSheet(BuildContext context, DraftAdvice advice) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraftAdviceSheet(advice: advice),
  );
}

class DraftAdviceSheet extends StatelessWidget {
  final DraftAdvice advice;

  const DraftAdviceSheet({super.key, required this.advice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(maxHeight: 680),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 34,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outline.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.auto_awesome, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Assistant Tactique IA',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Fermer',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            sectionTitle(context, 'CONSEIL IMMÉDIAT'),
            panel(
              context,
              child: Text(advice.summary, style: theme.textTheme.bodyMedium),
            ),
            if (advice.championAdvice.isNotEmpty) ...[
              const SizedBox(height: 12),
              sectionTitle(context, 'CHAMPIONS CONSEILLÉS'),
              Row(
                children: [
                  for (
                    var index = 0;
                    index < advice.championAdvice.length;
                    index++
                  ) ...[
                    if (index > 0) const SizedBox(width: 8),
                    Expanded(
                      child: championAdviceCard(
                        context,
                        advice.championAdvice[index],
                      ),
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.analytics_outlined, size: 18, color: scheme.primary),
                const SizedBox(width: 6),
                Text('ANALYSE FINALE', style: theme.textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 8),
            analysisSection(
              context,
              'POINTS FORTS',
              advice.strengths,
              const Color(0xFF54D5A5),
            ),
            const SizedBox(height: 8),
            analysisSection(
              context,
              'MENACES',
              advice.weaknesses,
              const Color(0xFFF44336),
            ),
            const SizedBox(height: 8),
            panel(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'CONDITION DE VICTOIRE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(advice.winCondition, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 10),
            winRatePanel(context, advice.winRate),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.keyboard_double_arrow_down),
              label: const Text('FERMER LE PANNEAU'),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.35,
        ),
      ),
    );
  }

  Widget panel(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }

  Widget championAdviceCard(BuildContext context, ChampionAdvice advice) {
    final theme = Theme.of(context);
    return panel(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(advice.champion, style: theme.textTheme.titleSmall),
          const SizedBox(height: 2),
          Text(
            '${formatPercent(advice.synergy)}% Synergie',
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFF54D5A5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget analysisSection(BuildContext context, String title, List<String> values, Color accent,) {
    final theme = Theme.of(context);
    return panel(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          for (final value in values)
            Text(value, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget winRatePanel(BuildContext context, double winRate) {
    final theme = Theme.of(context);
    final safeRate = winRate.clamp(0, 100).toDouble();
    return panel(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'PROBABILITÉ THÉORIQUE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Text(
                '${formatPercent(safeRate)}%',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: safeRate >= 50 ? const Color(0xFF54D5A5) : const Color(0xFFF44336),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: safeRate / 100,
                    backgroundColor: const Color(0xFFFFAAA8),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF54D5A5)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'vs composition adverse',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  String formatPercent(double value) =>
      value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
}
