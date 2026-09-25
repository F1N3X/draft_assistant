import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';

import '../models/champions.dart';
import '../providers/draft_provider.dart';

class ChampionAdvice {
  final String champion;
  final double synergy;

  const ChampionAdvice({required this.champion, required this.synergy});
}

class DraftAdvice {
  final String rawResponse;
  final String summary;
  final List<String> strengths;
  final List<String> weaknesses;
  final String winCondition;
  final List<ChampionAdvice> championAdvice;

  const DraftAdvice({
    required this.rawResponse,
    required this.summary,
    required this.strengths,
    required this.weaknesses,
    required this.winCondition,
    required this.championAdvice,
  });

  factory DraftAdvice.fromJson(String rawResponse) {
    final decoded = jsonDecode(stripCodeFence(rawResponse));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('La réponse IA n\'est pas un objet JSON.');
    }

    return DraftAdvice(
      rawResponse: rawResponse,
      summary: stringValue(decoded['summary']),
      strengths: stringList(decoded['strengths']),
      weaknesses: stringList(decoded['weaknesses']),
      winCondition: stringValue(decoded['win_condition']),
      championAdvice: championAdviceList(decoded['champion_advice']),
    );
  }
}

Future<DraftAdvice> generateDraftAdvice(DraftState draft) async {
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.5-flash-lite',
  );
  final response = await model.generateContent([
    Content.text(buildPrompt(draft)),
  ]);
  final rawResponse = response.text?.trim();
  if (rawResponse == null || rawResponse.isEmpty) {
    throw const FormatException('Firebase AI a renvoyé une réponse vide.');
  }
  return DraftAdvice.fromJson(rawResponse);
}

String buildPrompt(DraftState draft) {
  final myTeam = teamName(draft.myTeam);
  final blueChampions = championNames(draft.blueChampions);
  final redChampions = championNames(draft.redChampions);
  final blueBans = championNames(draft.blueBans);
  final redBans = championNames(draft.redBans);

  return '''Tu es coach League of Legends. Analyse cette draft très brièvement.
Notre équipe: $myTeam
Blue team - champions: $blueChampions
Blue team - bans: $blueBans
Red team - champions: $redChampions
Red team - bans: $redBans
Draft complète: ${draft.isComplete ? 'oui' : 'non'}

Réponds UNIQUEMENT avec un objet JSON valide, sans markdown ni texte avant/après,
en français, avec exactement ces clés:
{"summary":"...","strengths":["..."],"weaknesses":["..."],"win_condition":"...","champion_advice":[{"champion":"Jinx","synergy":85},{"champion":"Ashe","synergy":70.6}]}
Chaque valeur doit être ultra condensée: summary, win_condition et chaque élément
font au maximum 120 caractères; strengths et weaknesses contiennent au maximum 2 éléments.
Si la draft est complète, champion_advice doit être []. Sinon, donne exactement 2
conseils de champions jouables par notre équipe, avec leur nom et un pourcentage
de synergie entre 0 et 100, avec au maximum un chiffre après la virgule.
Ne propose jamais un champion déjà sélectionné ou banni.''';
}

String teamName(TeamSide team) => team == TeamSide.blue ? 'Bleue' : 'Rouge';

String championNames(List<Champions> champions) => champions.isEmpty
    ? 'aucun'
    : champions.map((champion) => champion.name).join(', ');

String stripCodeFence(String value) {
  final trimmed = value.trim();
  if (!trimmed.startsWith('```')) return trimmed;
  return trimmed
      .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
      .replaceFirst(RegExp(r'\s*```$'), '')
      .trim();
}

String stringValue(Object? value) => value is String ? value : '';

List<String> stringList(Object? value) => value is List
    ? value.whereType<String>().toList(growable: false)
    : const [];

List<ChampionAdvice> championAdviceList(Object? value) {
  if (value is! List) return const [];

  return value
      .whereType<Map>()
      .map((item) {
        final champion = item['champion'];
        final synergy = item['synergy'];
        if (champion is! String || synergy is! num) return null;
        return ChampionAdvice(champion: champion, synergy: synergy.toDouble());
      })
      .whereType<ChampionAdvice>()
      .toList(growable: false);
}
