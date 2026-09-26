import 'package:flutter_test/flutter_test.dart';
import 'package:draft_assistant/src/services/draft_persistence_service.dart';

void main() {
  test('decodeMap transforme un JSON en map', () {
    final result = decodeMap('{"winRate": 52.5, "team": "blue"}');

    expect(result['winRate'], 52.5);
    expect(result['team'], 'blue');
  });
}
