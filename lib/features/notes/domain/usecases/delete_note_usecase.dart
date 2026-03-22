import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/audio_file_store.dart';
import '../../../../core/database/app_database.dart';

class DeleteNoteUseCase {
  final AppDatabase _db;
  final AudioFileStore _audioFileStore;

  DeleteNoteUseCase(this._db, this._audioFileStore);

  Future<void> call(int noteId) async {
    final note = await _db.notesDao.getById(noteId);
    if (note != null && note.audioFilePath != null) {
      await _audioFileStore.delete(note.audioFilePath!);
    }
    await _db.notesDao.deleteById(noteId);
  }
}

final deleteNoteUseCaseProvider = Provider<DeleteNoteUseCase>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final audioStore = ref.watch(audioFileStoreProvider);
  return DeleteNoteUseCase(db, audioStore);
});
