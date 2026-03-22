import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../notes/domain/entities/note.dart';

class SearchNotesUseCase {
  final AppDatabase _db;

  SearchNotesUseCase(this._db);

  Future<List<Note>> call(String query) async {
    if (query.trim().isEmpty) return [];
    return _db.notesDao.getAll(searchQuery: query.trim());
  }
}

final searchNotesUseCaseProvider = Provider<SearchNotesUseCase>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SearchNotesUseCase(db);
});
