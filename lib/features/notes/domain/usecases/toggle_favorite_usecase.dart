import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';

class ToggleFavoriteUseCase {
  final AppDatabase _db;

  ToggleFavoriteUseCase(this._db);

  Future<void> call(int noteId) => _db.notesDao.toggleFavorite(noteId);
}

final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ToggleFavoriteUseCase(db);
});
