import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/champions_provider.dart';

Widget championsGrid(BuildContext context, WidgetRef ref) {
  final championsAsync = ref.watch(championsProvider);

  return championsAsync.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stackTrace) =>
        Center(child: Text('Impossible de charger les champions : $error')),
    data: (champions) {
      var searchQuery = '';

      return StatefulBuilder(
        builder: (context, setState) {
          final filteredChampions = champions
              .where(
                (champion) => champion.name.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
              )
              .toList(growable: false);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                child: TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
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
                      return const Center(child: Text('Aucun champion trouvé'));
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

                        return Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: champion.imageUrl.isEmpty
                                    ? const Icon(Icons.image_not_supported_outlined)
                                    : Image.network(
                                        champion.imageUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image_outlined),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  champion.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ],
                          ),
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
