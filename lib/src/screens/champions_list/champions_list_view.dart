import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/champions_grid.dart';
import 'package:draft_assistant/src/providers/draft_provider.dart';

class ChampionsList extends StatelessWidget {
  final DraftSlot slot;

  const ChampionsList({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedChampion = ref.watch(draftProvider).selectedFor(slot);

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              ref.read(draftProvider.notifier).clearSearchQuery(slot);
            }
          },
          child: Scaffold(
            appBar: draftAssistantAppBar(context, 'Champions List'),
            body: ChampionsGrid(slot: slot),
            bottomNavigationBar: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.35),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child:
                            selectedChampion == null ||
                                selectedChampion.imageUrl.isEmpty
                            ? Icon(
                                Icons.person_search_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  selectedChampion.imageUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.person_search_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20,
                                      ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SÉLECTIONNER POUR :',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Text(
                              slot.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.lock_outline, size: 17),
                  label: const Text('Valider'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: null,
                    minimumSize: const Size(94, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        );
      },
    );
  }
}
