import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

Widget draftAssistantBottomNavigationBar(BuildContext context, int selectedIndex) {
  return NavigationBar(
    selectedIndex: selectedIndex,
    onDestinationSelected: (index) {
      const routes = ['/', '/saves', '/profile'];
      context.go(routes[index]);
    },
    destinations: const [
      NavigationDestination(
        icon: const iconoir.Gamepad(),
        selectedIcon: const iconoir.Gamepad(),
        label: 'Draft',
      ),
      NavigationDestination(
        icon: const iconoir.Bookmark(),
        selectedIcon: const iconoir.Bookmark(),
        label: 'Sauvegardées',
      ),
      NavigationDestination(
        icon: const iconoir.User(),
        selectedIcon: const iconoir.User(),
        label: 'Profile',
      ),
    ],
  );
}