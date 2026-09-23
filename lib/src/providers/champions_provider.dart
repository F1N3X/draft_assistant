import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/champions.dart';
import '../services/champions_service.dart';

final championsServiceProvider = Provider<ChampionsService>((ref) {
  return ChampionsService();
});

final championsProvider = FutureProvider<List<Champions>>((ref) {
  final championsService = ref.watch(championsServiceProvider);
  return championsService.fetchChampions();
});
