import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/champions.dart';
import '../../providers/champions_provider.dart';
import '../../providers/draft_provider.dart';

class ChampionsGrid extends StatelessWidget {
  final DraftSlot slot;

  const ChampionsGrid({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final championsAsync = ref.watch(championsProvider);
        final draftState = ref.watch(draftProvider);
        final query = draftState.searchQueryFor(slot).trim().toLowerCase();

        return championsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('Impossible de charger les champions : $error'),
          ),
          data: (champions) {
            final filteredChampions = champions
                .where(
                  (champion) =>
                      !draftState.isPickedElsewhere(champion, slot) &&
                      champion.name.toLowerCase().contains(query),
                )
                .toList(growable: false);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                  child: TextField(
                    onChanged: (value) => ref
                      .read(draftProvider.notifier)
                      .setSearchQuery(slot, value),
                    decoration: InputDecoration(
                      hintText: 'Chercher un champion...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 900
                          ? 6
                          : constraints.maxWidth >= 600
                          ? 4
                          : 3;

                      if (filteredChampions.isEmpty) {
                        return const Center(
                          child: Text('Aucun champion trouvé'),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: filteredChampions.length,
                        itemBuilder: (context, index) {
                          final champion = filteredChampions[index];

                          return ChampionTile(
                            champion: champion,
                            isSelected:
                                draftState.selectedFor(slot)?.id == champion.id,
                            onTap: () => ref
                                .read(draftProvider.notifier)
                                .toggleChampion(slot, champion),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ChampionTile extends StatelessWidget {
  final Champions champion;
  final bool isSelected;
  final VoidCallback onTap;

  const ChampionTile({super.key, 
    required this.champion,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.35),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(child: championImage()),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                champion.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget championImage() {
    if (champion.imageUrl.isEmpty) {
      return const Icon(Icons.image_not_supported_outlined);
    }

    return Image.network(
      champion.imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image_outlined),
    );
  }
}
