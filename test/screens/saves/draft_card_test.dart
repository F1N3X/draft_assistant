import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:draft_assistant/src/screens/saves/saves_view.dart';
import 'package:draft_assistant/src/services/draft_persistence_service.dart';

void main() {
  testWidgets('DraftCard affiche le taux de victoire et le bouton détails', (
    tester,
  ) async {
    final draft = SavedDraftRecord(
      id: 'draft-1',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
      myTeam: 'blue',
      selections: const {},
      aiAdvice: const {'winRate': 52.5},
    );

    await tester.pumpWidget(MaterialApp(home: DraftCard(draft: draft)));

    expect(find.text('52.5% WR'), findsOneWidget);
    expect(find.text('Détails'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });
}
