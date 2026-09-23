import 'package:dio/dio.dart';
import '../models/champions.dart';

class ChampionsService {
  final Dio _dio;
  
  ChampionsService({Dio? dio}) : _dio = dio ?? Dio();

  static const _championsUrl = 'https://ddragon.leagueoflegends.com/cdn/13.1.1/data/en_US/champion.json';

  Future<List<Champions>> fetchChampions() async {
    final response = await _dio.get<Map<String, dynamic>>(_championsUrl);
    final data = response.data?['data'];

    if (data == null) {
      throw Exception('Aucune donnée reçue');
    }

    return data.values
        .map((champion) => Champions.fromJson(champion as Map<String, dynamic>))
        .toList(growable: false);
  }
}
