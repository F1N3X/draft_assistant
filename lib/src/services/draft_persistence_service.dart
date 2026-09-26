import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/saved_draft.dart';
import '../providers/draft_provider.dart';
import 'ai_service.dart';
import 'objectbox_service.dart';

Future<void> saveDraft({required String uid, required DraftState draft, required ObjectBoxService objectBox,}) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  final draftReference = FirebaseFirestore.instance.collection('drafts').doc();
  final data = draftData(draft, uid, now);

  await draftReference.set(data);
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'draftIds': FieldValue.arrayUnion([draftReference.id]),
  }, SetOptions(merge: true));

  objectBox.drafts.put(
    SavedDraft(
      createdAt: now,
      updatedAt: now,
      myTeam: draft.myTeam.name,
      selectionsJson: jsonEncode(selectionData(draft)),
      aiAdviceJson: jsonEncode(adviceData(draft.aiAdvice)),
    ),
  );
}

Map<String, dynamic> draftData(DraftState draft, String uid, int timestamp) {
  return {
    'userId': uid,
    'createdAt': Timestamp.fromMillisecondsSinceEpoch(timestamp),
    'updatedAt': Timestamp.fromMillisecondsSinceEpoch(timestamp),
    'myTeam': draft.myTeam.name,
    'selections': selectionData(draft),
    'aiAdvice': adviceData(draft.aiAdvice),
  };
}

Map<String, dynamic> selectionData(DraftState draft) {
  return {
    for (final entry in draft.selections.entries)
      entry.key.id: {
        'id': entry.value.id,
        'key': entry.value.key,
        'name': entry.value.name,
        'imageUrl': entry.value.imageUrl,
      },
  };
}

Map<String, dynamic> adviceData(DraftAdvice? advice) {
  if (advice == null) return {};

  return {
    'rawResponse': advice.rawResponse,
    'summary': advice.summary,
    'strengths': advice.strengths,
    'weaknesses': advice.weaknesses,
    'winCondition': advice.winCondition,
    'winRate': advice.winRate,
    'championAdvice': [
      for (final item in advice.championAdvice)
        {'champion': item.champion, 'synergy': item.synergy},
    ],
  };
}
