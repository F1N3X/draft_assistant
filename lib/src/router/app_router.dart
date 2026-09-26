import "package:go_router/go_router.dart";
import "package:draft_assistant/src/screens/draft/champions_list_view.dart";
import "package:draft_assistant/src/screens/draft/draft_view.dart";
import "package:draft_assistant/src/screens/profile/profile_view.dart";
import "package:draft_assistant/src/screens/saves/saves_view.dart";
import "package:draft_assistant/src/screens/saves/saved_draft_detail_view.dart";
import "package:draft_assistant/src/providers/draft_provider.dart";

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/', 
      builder: (context, state) => 
          const DraftView()),
    GoRoute(
      path: '/saves', 
      builder: (context, state) => 
          const SavesView()),
    GoRoute(
      path: '/saves/:draftId',
      name: 'saved-draft-detail',
      builder: (context, state) =>
          SavedDraftDetailView(draftId: state.pathParameters['draftId']!),
    ),
    GoRoute(
      path: '/profile', 
      builder: (context, state) => 
          const ProfileView()),
    GoRoute(
      path: '/champions-list',
      name: 'champions-list',
      builder: (context, state) => ChampionsList(
        slot: DraftSlot.fromId(
          state.uri.queryParameters['slot'] ?? DraftSlot.blueBan1.id,
        ),
      ),
    ),
  ],
);
