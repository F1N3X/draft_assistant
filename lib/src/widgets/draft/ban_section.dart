import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:draft_assistant/src/providers/draft_provider.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

Widget banSection(BuildContext context, WidgetRef ref, DraftState draft, {required List<List<DraftSlot>> slots,}) {
  final theme = Theme.of(context);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface.withValues(alpha: 0.42),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.35),
      ),
    ),
    child: Column(
      children: [
        for (var index = 0; index < slots.length; index++) ...[
          if (index > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Divider(
                height: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.16),
              ),
            ),
          Row(
            children: [
              SizedBox(
                width: 68,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: slots[index].first.isBlue
                            ? const Color(0xFFB5C9FF)
                            : const Color(0xFFFFAAA8),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        slots[index].first.isBlue ? 'BLEU' : 'ROUGE',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: slots[index].first.isBlue
                              ? const Color(0xFFB5C9FF)
                              : const Color(0xFFFFAAA8),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Row(
                  children: [
                    for (final slot in slots[index])
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: banSlotButton(context, ref, draft, slot),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget banSlotButton(BuildContext context, WidgetRef ref, DraftState draft, DraftSlot slot,) {
  final champion = draft.selectedFor(slot);
  final theme = Theme.of(context);
  final accent = slot.isBlue
      ? const Color(0xFFB5C9FF)
      : const Color(0xFFFFAAA8);

  return AspectRatio(
    aspectRatio: 1,
    child: Tooltip(
      message: slot.label,
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: () => context.pushNamed(
                'champions-list',
                queryParameters: {'slot': slot.id},
              ),
              borderRadius: BorderRadius.circular(5),
              child: Ink(
                decoration: BoxDecoration(
                  color: champion == null
                      ? theme.colorScheme.surface.withValues(alpha: 0.22)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: champion == null
                        ? accent.withValues(alpha: 0.42)
                        : accent.withValues(alpha: 0.72),
                    width: champion == null ? 1 : 1.25,
                  ),
                ),
                child: champion == null
                    ? Center(child: iconoir.Plus(color: accent))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: champion.imageUrl.isEmpty
                            ? Icon(
                                Icons.image_not_supported_outlined,
                                color: theme.colorScheme.outline,
                              )
                            : Image.network(
                                champion.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.broken_image_outlined,
                                      color: theme.colorScheme.outline,
                                    ),
                              ),
                      ),
              ),
            ),
          ),
          if (champion != null)
            Positioned(
              top: 3,
              right: 3,
              child: Material(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  onTap: () => ref
                      .read(draftProvider.notifier)
                      .toggleChampion(slot, champion),
                  borderRadius: BorderRadius.circular(4),
                  child: const SizedBox(
                    width: 18,
                    height: 18,
                    child: Icon(Icons.close, size: 13, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}