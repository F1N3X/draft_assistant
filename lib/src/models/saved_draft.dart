import 'package:objectbox/objectbox.dart';

@Entity()
class SavedDraft {
  @Id()
  int id = 0;

  int createdAt;
  int updatedAt;
  String myTeam;
  String selectionsJson;
  String aiAdviceJson;

  SavedDraft({
    required this.createdAt,
    required this.updatedAt,
    required this.myTeam,
    required this.selectionsJson,
    required this.aiAdviceJson,
  });
}
