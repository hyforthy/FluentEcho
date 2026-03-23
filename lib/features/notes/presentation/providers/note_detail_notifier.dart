import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/note.dart';

/// Note detail provider (family keyed by noteId)
final noteDetailProvider = FutureProvider.family<Note, int>((ref, noteId) async {
  final db = ref.read(appDatabaseProvider);
  final row = await db.notesDao.getById(noteId);
  if (row == null) throw StateError('Note $noteId not found');

  return Note(
    id: row.id,
    originalText: row.originalText,
    optimizedText: row.optimizedText,
    translatedText: row.translatedText,
    detectedLanguage: row.detectedLanguage,
    detectionConfidence: row.detectionConfidence,
    audioFilePath: row.audioFilePath,
    audioFileSizeBytes: row.audioFileSizeBytes,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    isFavorite: row.isFavorite,
    skipOptimization: row.skipOptimization,
  );
});

/// noteRepositoryProvider — used by NoteDetailScreen to call clearAudioPath / updateAudioPath
final noteRepositoryProvider = Provider<_NoteRepository>((ref) {
  return _NoteRepository(ref.read(appDatabaseProvider));
});

class _NoteRepository {
  final AppDatabase _db;

  _NoteRepository(this._db);

  Future<void> clearAudioPath(int noteId) => _db.notesDao.clearAudioPath(noteId);

  Future<void> updateAudioPath(int noteId, String path) =>
      _db.notesDao.updateAudioPath(noteId, path);

  Future<String?> getAudioPath(int noteId) async {
    final note = await _db.notesDao.getById(noteId);
    return note?.audioFilePath;
  }

  /// Sync note content after skip-optimize: updates text, translation,
  /// marks skipOptimization=true, clears audio path.
  Future<void> updateSkippedContent(
    int noteId, {
    required String text,
    required String? translatedText,
  }) =>
      (_db.update(_db.notes)..where((n) => n.id.equals(noteId))).write(
        NotesCompanion(
          originalText: Value(text),
          optimizedText: Value(text),
          translatedText: Value(translatedText),
          skipOptimization: const Value(true),
          audioFilePath: const Value(null),
          updatedAt: Value(DateTime.now()),
        ),
      );

  /// Sync note content after a full re-optimization pass.
  Future<void> updateReoptimizedContent(
    int noteId, {
    required String originalText,
    required String optimizedText,
    required String? translatedText,
  }) =>
      (_db.update(_db.notes)..where((n) => n.id.equals(noteId))).write(
        NotesCompanion(
          originalText: Value(originalText),
          optimizedText: Value(optimizedText),
          translatedText: Value(translatedText),
          skipOptimization: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );
}
