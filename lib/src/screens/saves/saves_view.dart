import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/bottom_navigation_bar.dart';
import 'package:draft_assistant/src/services/draft_persistence_service.dart';
import 'package:draft_assistant/src/services/objectbox_service.dart';
import 'package:draft_assistant/src/widgets/saves/list/message.dart';
import 'package:draft_assistant/src/widgets/saves/list/draft_card.dart';

class SavesView extends StatelessWidget {
  const SavesView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Draft sauvegardées'),
      body: Consumer(
        builder: (context, ref, child) {
          return user == null
              ? const Message(text: 'Connecte-toi pour retrouver tes drafts.')
              : FutureBuilder<List<SavedDraftRecord>>(
                  future: loadSavedDrafts(
                    uid: user.uid,
                    objectBox: ref.read(objectBoxProvider),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Message(
                        text: 'Impossible de charger les drafts.',
                      );
                    }
                    final drafts = snapshot.data ?? const <SavedDraftRecord>[];
                    if (drafts.isEmpty) {
                      return const Message(text: 'Aucune draft sauvegardée.');
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: drafts.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                        DraftCard(draft: drafts[index]),
                    );
                  },
                );
        },
      ),
      bottomNavigationBar: draftAssistantBottomNavigationBar(context, 1),
    );
  }
}
