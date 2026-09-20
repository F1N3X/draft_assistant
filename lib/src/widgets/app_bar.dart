import 'package:flutter/material.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:go_router/go_router.dart';

PreferredSizeWidget draftAssistantAppBar(BuildContext context, String title) {
  return AppBar(
    title: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(
          'assets/icons/draft_assistant_logo.png',
          width: 48,
          height: 48,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Draft Assistant',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const iconoir.User(),
        tooltip: 'Ouvrir le profil',
        onPressed: () {
          context.go('/profile');
        },
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ],
  );
}
