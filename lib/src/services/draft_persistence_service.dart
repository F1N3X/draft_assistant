import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/saved_draft.dart';
import '../providers/draft_provider.dart';
import 'ai_service.dart';
import 'objectbox_service.dart';

Future<void> saveDraft({
  required String uid,
  required DraftState draft,
  required ObjectBoxService objectBox,
}) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  final data = draftData(draft, uid, now);

  try {
    final draftReference = FirebaseFirestore.instance
        .collection('drafts')
        .doc();
    await draftReference.set(data);
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'draftIds': FieldValue.arrayUnion([draftReference.id]),
    }, SetOptions(merge: true));
  } catch (_) {
  }

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

class SavedDraftRecord {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String myTeam;
  final Map<String, dynamic> selections;
  final Map<String, dynamic> aiAdvice;

  const SavedDraftRecord({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.myTeam,
    required this.selections,
    required this.aiAdvice,
  });

  factory SavedDraftRecord.fromSavedDraft(SavedDraft draft) {
    return SavedDraftRecord(
      id: 'local-${draft.id}',
      createdAt: DateTime.fromMillisecondsSinceEpoch(draft.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(draft.updatedAt),
      myTeam: draft.myTeam,
      selections: decodeMap(draft.selectionsJson),
      aiAdvice: decodeMap(draft.aiAdviceJson),
    );
  }

  factory SavedDraftRecord.fromFirestore(String id, Map<String, dynamic> data) {
    return SavedDraftRecord(
      id: id,
      createdAt: dateValue(data['createdAt']),
      updatedAt: dateValue(data['updatedAt']),
      myTeam: data['myTeam'] as String? ?? 'blue',
      selections: mapValue(data['selections']),
      aiAdvice: mapValue(data['aiAdvice']),
    );
  }
}

Future<List<SavedDraftRecord>> loadSavedDrafts({
  required String uid,
  required ObjectBoxService objectBox,
}) async {
  try {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final draftIds = userSnapshot.data()?['draftIds'];
    if (draftIds is! List) throw StateError('Aucun index Firestore valide.');

    final drafts = await Future.wait(
      draftIds.whereType<String>().map((id) async {
        final snapshot = await FirebaseFirestore.instance
            .collection('drafts')
            .doc(id)
            .get();
        final data = snapshot.data();
        return data == null ? null : SavedDraftRecord.fromFirestore(id, data);
      }),
    );
    return drafts.whereType<SavedDraftRecord>().toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  } catch (_) {
    return objectBox.drafts
        .getAll()
        .map(SavedDraftRecord.fromSavedDraft)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }
}

Future<SavedDraftRecord?> loadSavedDraft({
  required String uid,
  required String id,
  required ObjectBoxService objectBox,
}) async {
  if (id.startsWith('local-')) {
    final localId = int.tryParse(id.substring(6));
    final local = localId == null ? null : objectBox.drafts.get(localId);
    return local == null ? null : SavedDraftRecord.fromSavedDraft(local);
  }

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('drafts')
        .doc(id)
        .get();
    final data = snapshot.data();
    if (data != null && data['userId'] == uid) {
      return SavedDraftRecord.fromFirestore(id, data);
    }
  } catch (_) {
  }
  return null;
}

Map<String, dynamic> decodeMap(String value) {
  final decoded = jsonDecode(value);
  return mapValue(decoded);
}

Map<String, dynamic> mapValue(Object? value) {
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  return {};
}

DateTime dateValue(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is num) return DateTime.fromMillisecondsSinceEpoch(value.toInt());
  return DateTime.fromMillisecondsSinceEpoch(0);
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
