import 'package:flutter/material.dart';

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