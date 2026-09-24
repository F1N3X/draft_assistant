import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/champions.dart';

enum TeamSide { blue, red }

enum DraftSlotType { ban, champion }

enum DraftSlot {
  blueBan1(TeamSide.blue, DraftSlotType.ban, 1),
  blueBan2(TeamSide.blue, DraftSlotType.ban, 2),
  blueBan3(TeamSide.blue, DraftSlotType.ban, 3),
  blueBan4(TeamSide.blue, DraftSlotType.ban, 4),
  blueBan5(TeamSide.blue, DraftSlotType.ban, 5),
  redBan1(TeamSide.red, DraftSlotType.ban, 1),
  redBan2(TeamSide.red, DraftSlotType.ban, 2),
  redBan3(TeamSide.red, DraftSlotType.ban, 3),
  redBan4(TeamSide.red, DraftSlotType.ban, 4),
  redBan5(TeamSide.red, DraftSlotType.ban, 5),
  blueChampion1(TeamSide.blue, DraftSlotType.champion, 1),
  blueChampion2(TeamSide.blue, DraftSlotType.champion, 2),
  blueChampion3(TeamSide.blue, DraftSlotType.champion, 3),
  blueChampion4(TeamSide.blue, DraftSlotType.champion, 4),
  blueChampion5(TeamSide.blue, DraftSlotType.champion, 5),
  redChampion1(TeamSide.red, DraftSlotType.champion, 1),
  redChampion2(TeamSide.red, DraftSlotType.champion, 2),
  redChampion3(TeamSide.red, DraftSlotType.champion, 3),
  redChampion4(TeamSide.red, DraftSlotType.champion, 4),
  redChampion5(TeamSide.red, DraftSlotType.champion, 5);

  final TeamSide team;
  final DraftSlotType type;
  final int number;

  const DraftSlot(this.team, this.type, this.number);

  String get id => name;

  bool get isBlue => team == TeamSide.blue;

  bool get isBan => type == DraftSlotType.ban;

  String get label {
    final sideName = isBlue ? 'Bleu' : 'Rouge';
    final slotType = isBan ? 'Ban' : 'Champion';
    return '$slotType $sideName $number';
  }

  static DraftSlot fromId(String id) {
    return DraftSlot.values.firstWhere(
      (slot) => slot.id == id,
      orElse: () => DraftSlot.blueBan1,
    );
  }
}

class DraftState {
  final Map<DraftSlot, Champions> selections;
  final Map<DraftSlot, String> searchQueries;
  final TeamSide myTeam;

  const DraftState({
    this.selections = const {},
    this.searchQueries = const {},
    this.myTeam = TeamSide.blue,
  });

  Champions? selectedFor(DraftSlot slot) => selections[slot];

  String searchQueryFor(DraftSlot slot) => searchQueries[slot] ?? '';

  bool isPickedElsewhere(Champions champion, DraftSlot currentSlot) {
    return selections.entries.any(
      (entry) => entry.key != currentSlot && entry.value.id == champion.id,
    );
  }

  List<Champions> championsFor(TeamSide team, DraftSlotType type) {
    return selections.entries
        .where((entry) => entry.key.team == team && entry.key.type == type)
        .map((entry) => entry.value)
        .toList(growable: false);
  }
  
  List<Champions> get blueBans => championsFor(TeamSide.blue, DraftSlotType.ban);

  List<Champions> get redBans => championsFor(TeamSide.red, DraftSlotType.ban);

  List<Champions> get blueChampions => championsFor(TeamSide.blue, DraftSlotType.champion);

  List<Champions> get redChampions => championsFor(TeamSide.red, DraftSlotType.champion);

  DraftState copyWith({
    Map<DraftSlot, Champions>? selections,
    Map<DraftSlot, String>? searchQueries,
    TeamSide? myTeam,
  }) {
    return DraftState(
      selections: selections ?? this.selections,
      searchQueries: searchQueries ?? this.searchQueries,
      myTeam: myTeam ?? this.myTeam,
    );
  }
}

class DraftNotifier extends Notifier<DraftState> {
  @override
  DraftState build() => const DraftState();

  void toggleChampion(DraftSlot slot, Champions champion) {
    final selectedChampion = state.selectedFor(slot);

    if (selectedChampion?.id == champion.id) {
      final selections = Map<DraftSlot, Champions>.from(state.selections)
        ..remove(slot);
      state = state.copyWith(selections: selections);
      return;
    }

    if (state.isPickedElsewhere(champion, slot)) {
      return;
    }

    final selections = Map<DraftSlot, Champions>.from(state.selections)
      ..[slot] = champion;
    state = state.copyWith(selections: selections);
  }

  void setMyTeam(TeamSide team) {
    state = state.copyWith(myTeam: team);
  }

  void setSearchQuery(DraftSlot slot, String query) {
    final searchQueries = Map<DraftSlot, String>.from(state.searchQueries)
      ..[slot] = query;
    state = state.copyWith(searchQueries: searchQueries);
  }

  void clearSearchQuery(DraftSlot slot) {
    final searchQueries = Map<DraftSlot, String>.from(state.searchQueries)
      ..remove(slot);
    state = state.copyWith(searchQueries: searchQueries);
  }

}

final draftProvider = NotifierProvider<DraftNotifier, DraftState>(
  DraftNotifier.new,
);
