import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:draft_assistant/src/services/google_auth.dart';
import 'package:draft_assistant/src/services/firestore_service.dart';

class SignedInProfile extends StatelessWidget {
  final User user;

  const SignedInProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          profileHeader(context),
          const SizedBox(height: 12),
          FutureBuilder<int>(
            future: getSavedDraftCount(user.uid),
            builder: (context, snapshot) {
              final count = snapshot.data;
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      snapshot.connectionState == ConnectionState.waiting
                          ? '...'
                          : '${count ?? 0}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'DRAFTS SAUVEGARDÉES',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () async {
              await signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

  Widget profileHeader(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: scheme.secondary,
            backgroundImage: user.photoURL == null
                ? null
                : NetworkImage(user.photoURL!),
            child: user.photoURL == null
                ? Icon(Icons.person, size: 42, color: scheme.primary)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            user.displayName ?? 'Joueur',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          if (user.email != null) ...[
            const SizedBox(height: 4),
            Text(
              user.email!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
