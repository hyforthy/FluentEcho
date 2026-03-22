import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';

class SaveNoteUseCase {
  final AppDatabase _db;

  SaveNoteUseCase(this._db);

  Future<int> call({
    required String originalText,
    String? optimizedText,
    String? translatedText,
    required String detectedLanguage,
    required double confidence,
  }) async {
    final now = DateTime.now();
    return _db.notesDao.insert(
      NotesCompanion.insert(
        originalText: originalText,
        optimizedText: Value(optimizedText),
        translatedText: Value(translatedText),
        detectedLanguage: Value(detectedLanguage),
        detectionConfidence: Value(confidence),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}

final saveNoteUseCaseProvider = Provider<SaveNoteUseCase>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SaveNoteUseCase(db);
});
