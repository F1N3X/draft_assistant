import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:draft_assistant/src/services/google_auth.dart';

class SignedOutProfile extends StatelessWidget {
  const SignedOutProfile({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 48),
            CircleAvatar(
              radius: 34,
              backgroundColor: scheme.surface,
              child: Icon(
                Icons.person_outline,
                size: 38,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text('MODE INVITÉ', style: theme.textTheme.labelSmall),
            const SizedBox(height: 24),
            Text(
              'Synchronisez vos compositions',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Connectez-vous pour sauvegarder vos drafts et retrouver vos analyses tactiques, et les retrouver sur vos appareils.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: SignInButton(
                Buttons.google,
                onPressed: () => signInWithGoogle(context),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Connexion instantanée et sécurisée via votre compte Google',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}