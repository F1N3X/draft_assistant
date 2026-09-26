import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../objectbox.g.dart';
import '../models/saved_draft.dart';

class ObjectBoxService {
  final Store store;
  late final Box<SavedDraft> drafts = store.box<SavedDraft>();

  ObjectBoxService._(this.store);

  static Future<ObjectBoxService> create() async {
    final directory = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: '${directory.path}/objectbox');
    return ObjectBoxService._(store);
  }

  void close() => store.close();
}

final objectBoxProvider = Provider<ObjectBoxService>((ref) {
  throw StateError('ObjectBox n\'est pas initialisé.');
});
