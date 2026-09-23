import 'package:flutter/material.dart';

class ChampionsList extends StatelessWidget {
  const ChampionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Liste des champions',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
