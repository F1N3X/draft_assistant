import 'package:flutter/material.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class DraftView extends StatelessWidget {
  const DraftView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/icons/draft_assistant_logo.png',
              width: 128,
              height: 128,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Draft Assistant', style: TextStyle(fontSize: 12)),
                Text('Live Draft'),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const iconoir.User(),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('This is the Draft View'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          // navigation logic
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
      ),
    );
  }
}