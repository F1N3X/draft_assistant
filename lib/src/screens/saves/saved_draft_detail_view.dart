import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:draft_assistant/src/services/draft_persistence_service.dart';
import 'package:draft_assistant/src/services/objectbox_service.dart';
import 'package:draft_assistant/src/widgets/app_bar.dart';
import 'package:draft_assistant/src/widgets/saves/detail/detail_content.dart';

class SavedDraftDetailView extends ConsumerWidget {
  final String draftId;

  const SavedDraftDetailView({super.key, required this.draftId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Connexion requise.')));
    }

    return Scaffold(
      appBar: draftAssistantAppBar(context, 'Détail de la draft'),
      body: FutureBuilder<SavedDraftRecord?>(
        future: loadSavedDraft(
          uid: user.uid,
          id: draftId,
          objectBox: ref.read(objectBoxProvider),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final draft = snapshot.data;
          if (draft == null) {
            return const Center(child: Text('Cette draft est introuvable.'));
          }
          return DetailContent(draft: draft);
        },
      ),
    );
  }
}
