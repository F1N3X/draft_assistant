import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:draft_assistant/src/providers/draft_provider.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

Widget banSection(BuildContext context, WidgetRef ref, DraftState draft, {required List<List<DraftSlot>> slots,}) {
  final theme = Theme.of(context);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.3),
      ),
    ),
    child: Column(
      children: [
        for (var index = 0; index < slots.length; index++) ...[
          if (index > 0) const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 72,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: slots[index].first.isBlue
                            ? const Color(0xFFB5C9FF)
                            : const Color(0xFFFFAAA8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      slots[index].first.isBlue ? 'BLEU' : 'ROUGE',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: slots[index].first.isBlue
                            ? const Color(0xFFB5C9FF)
                            : const Color(0xFFFFAAA8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    for (final slot in slots[index])
                      banSlotButton(context, ref, draft, slot),
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

  return Expanded(
    child: AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Tooltip(
          message: slot.label,
          child: Stack(
            children: [
              Positioned.fill(
                child: champion == null || champion.imageUrl.isEmpty
                    ? GestureDetector(
                        onTap: () => context.pushNamed(
                          'champions-list',
                          queryParameters: {'slot': slot.id},
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: slot.isBlue
                                  ? const Color(0xFF7082A4)
                                  : const Color(0xFF936B73),
                            ),
                          ),
                          child: Center(
                            child: iconoir.Plus(
                              color: slot.isBlue
                                  ? const Color(0xFFB5C9FF)
                                  : const Color(0xFFFFAAA8),
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () => context.pushNamed(
                          'champions-list',
                          queryParameters: {'slot': slot.id},
                        ),
                        borderRadius: BorderRadius.circular(4),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: slot.isBlue
                                  ? const Color(0xFF7082A4)
                                  : const Color(0xFF936B73),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Image.network(
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
              if (champion != null && champion.imageUrl.isNotEmpty)
                Positioned(
                  top: 1,
                  right: 1,
                  child: GestureDetector(
                    onTap: () => ref
                        .read(draftProvider.notifier)
                        .toggleChampion(slot, champion),
                    child: Container(
                      width: 18,
                      height: 18,
                      color: Colors.black.withValues(alpha: 0.65),
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
