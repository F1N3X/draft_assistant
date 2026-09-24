import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:draft_assistant/src/providers/draft_provider.dart';

Widget teamSideSelector(BuildContext context, WidgetRef ref, DraftState draft) {
  final theme = Theme.of(context);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface.withValues(alpha: 0.42),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.35),
      ),
    ),
    child: Row(
      children: [
        Icon(Icons.swap_horiz, size: 18, color: theme.colorScheme.outline),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'VOTRE CAMP :',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.outline,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFF061522),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              teamSideOption(
                context,
                ref,
                draft.myTeam,
                TeamSide.blue,
                'BLUE SIDE',
              ),
              teamSideOption(
                context,
                ref,
                draft.myTeam,
                TeamSide.red,
                'RED SIDE',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget teamSideOption(
  BuildContext context,
  WidgetRef ref,
  TeamSide selectedTeam,
  TeamSide team,
  String label,
) {
  final theme = Theme.of(context);
  final isSelected = selectedTeam == team;
  final isBlue = team == TeamSide.blue;
  final accent = isBlue
      ? const Color(0xFFB5C9FF)
      : const Color(0xFFFFAAA8);

  return Semantics(
    button: true,
    selected: isSelected,
    label: '${isBlue ? 'Blue' : 'Red'} side',
    child: InkWell(
      onTap: () => ref.read(draftProvider.notifier).setMyTeam(team),
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 88,
        decoration: BoxDecoration(
          color: isSelected ? accent : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? (isBlue
                        ? const Color(0xFF092845)
                        : const Color(0xFF703C47))
                    : theme.colorScheme.outline.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? const Color(0xFF092845)
                    : theme.colorScheme.onSecondary,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
