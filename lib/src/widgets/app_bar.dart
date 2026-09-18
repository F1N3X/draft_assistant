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
            Text('Draft Assistant', style: TextStyle(fontSize: 12)),
            Text(title),
          ],
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const iconoir.User(),
        onPressed: () {
          context.go('/profile');
        },
      ),
    ],
  );
}