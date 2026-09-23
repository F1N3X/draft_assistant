import "package:go_router/go_router.dart";
import "package:draft_assistant/src/screens/champions_list/champions_list_view.dart";
import "package:draft_assistant/src/screens/draft/draft_view.dart";
import "package:draft_assistant/src/screens/profile/profile_view.dart";
import "package:draft_assistant/src/screens/saves/saves_view.dart";

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DraftView(),
    ),
    GoRoute(
      path: '/saves',
      builder: (context, state) => const SavesView(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: '/champions-list',
      name: 'champions-list',
      builder: (context, state) => ChampionsList(
        label: state.uri.queryParameters['label'] ?? 'Ban',
      ),
    ),
  ],
);