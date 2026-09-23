import 'package:flutter/material.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class DraftView extends StatelessWidget {
  const DraftView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Live Draft'),
      body: Center(
        child: Column( // Column globale de la page
          children: [
            Column( // Column pour la phase 1 et les bans
              children: [
                const SizedBox(height: 16),
                Text(
                  'PHASE 1 : SÉLECTION',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Container( // Container pour les bans
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Column( // Column pour Bleu et Rouge
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bleu',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(40, 40),
                                    ),
                                    child: iconoir.Plus(color: Theme.of(context).colorScheme.primary),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rouge',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(40, 40),
                                    ),
                                    child: iconoir.Plus(color: Theme.of(context).colorScheme.primary),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]
                  )
                ),
              ],
            ),
          ]
        ),
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 0),
    );
  }
}
