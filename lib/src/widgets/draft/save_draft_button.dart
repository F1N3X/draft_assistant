import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:draft_assistant/src/providers/draft_provider.dart';
import 'package:draft_assistant/src/services/objectbox_service.dart';

Widget saveDraftButton(BuildContext context, WidgetRef ref, DraftState draft, User user,) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: draft.isSavingDraft
            ? null
            : () async {
                final saved = await ref
                    .read(draftProvider.notifier)
                    .saveDraft(user.uid, ref.read(objectBoxProvider));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      saved
                          ? 'Draft sauvegardée sur Firestore et en local.'
                          : 'Impossible de sauvegarder la draft.',
                    ),
                  ),
                );
              },
        icon: draft.isSavingDraft
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.bookmark_border),
        label: Text(
          draft.isSavingDraft ? 'SAUVEGARDE...' : 'SAUVEGARDER LA DRAFT',
        ),
      ),
    );
  }