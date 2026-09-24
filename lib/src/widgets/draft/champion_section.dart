import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:draft_assistant/src/providers/draft_provider.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

Widget championSection(BuildContext context, WidgetRef ref, DraftState draft,) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: championTeamColumn(
          context,
          ref,
          draft,
          TeamSide.blue,
          const [
            DraftSlot.blueChampion1,
            DraftSlot.blueChampion2,
            DraftSlot.blueChampion3,
            DraftSlot.blueChampion4,
            DraftSlot.blueChampion5,
          ],
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: championTeamColumn(
          context,
          ref,
          draft,
          TeamSide.red,
          const [
            DraftSlot.redChampion1,
            DraftSlot.redChampion2,
            DraftSlot.redChampion3,
            DraftSlot.redChampion4,
            DraftSlot.redChampion5,
          ],
        ),
      ),
    ],
  );
}

Widget championTeamColumn(BuildContext context, WidgetRef ref, DraftState draft, TeamSide team, List<DraftSlot> slots,) {
  final theme = Theme.of(context);
  final isBlue = team == TeamSide.blue;
  final accent = isBlue
      ? const Color(0xFFB5C9FF)
      : const Color(0xFFFFAAA8);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                isBlue ? 'Blue team' : 'Red team',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      for (final slot in slots) ...[
        championSlotButton(context, ref, draft, slot),
        const SizedBox(height: 8),
      ],
    ],
  );
}

Widget championSlotButton(BuildContext context, WidgetRef ref, DraftState draft, DraftSlot slot,) {
  final theme = Theme.of(context);
  final champion = draft.selectedFor(slot);
  final accent = slot.isBlue
      ? const Color(0xFFB5C9FF)
      : const Color(0xFFFFAAA8);

  return SizedBox(
    height: 62,
    child: InkWell(
      onTap: () => context.pushNamed(
        'champions-list',
        queryParameters: {'slot': slot.id},
      ),
      borderRadius: BorderRadius.circular(5),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: champion == null
                ? theme.colorScheme.outline.withValues(alpha: 0.35)
                : accent.withValues(alpha: 0.55),
          ),
        ),
        child: champion == null
            ? Center(child: iconoir.Plus(color: accent))
            : Row(
                children: [
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: champion.imageUrl.isEmpty
                          ? Icon(Icons.image_not_supported_outlined,
                              color: theme.colorScheme.outline)
                          : Image.network(
                              champion.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image_outlined,
                                      color: theme.colorScheme.outline),
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      champion.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: () => ref
                        .read(draftProvider.notifier)
                        .toggleChampion(slot, champion),
                    icon: const Icon(Icons.close),
                    iconSize: 17,
                    visualDensity: VisualDensity.compact,
                    color: theme.colorScheme.outline,
                    tooltip: 'Retirer ${champion.name}',
                  ),
                ],
              ),
      ),
    ),
  );
}