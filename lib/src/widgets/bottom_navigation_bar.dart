import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

Widget draftAssistantBottomNavigationBar(BuildContext context, int selectedIndex) {
  final scheme = Theme.of(context).colorScheme;

  return NavigationBar(
    selectedIndex: selectedIndex,
    onDestinationSelected: (index) {
      const routes = ['/', '/saves', '/profile'];
      context.go(routes[index]);
    },
    destinations: [
      NavigationDestination(
        icon: iconoir.Gamepad(color: scheme.onSecondary),
        selectedIcon: iconoir.Gamepad(color: scheme.primary),
        label: 'Draft',
      ),
      NavigationDestination(
        icon: iconoir.Bookmark(color: scheme.onSecondary),
        selectedIcon: iconoir.Bookmark(color: scheme.primary),
        label: 'Sauvegardées',
      ),
      NavigationDestination(
        icon: iconoir.User(color: scheme.onSecondary),
        selectedIcon: iconoir.User(color: scheme.primary),
        label: 'Profile',
      ),
    ],
  );
}