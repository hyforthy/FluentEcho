import '../../../../core/database/app_database.dart';

class AddTagToNoteUseCase {
  final AppDatabase _db;

  AddTagToNoteUseCase(this._db);

  Future<void> call(int noteId, String tagName) async {
    final tagId = await _db.tagsDao.insertOrGetByName(tagName);
    await _db.tagsDao.addTagToNote(noteId, tagId);
  }
}

class RemoveTagFromNoteUseCase {
  final AppDatabase _db;

  RemoveTagFromNoteUseCase(this._db);

  Future<void> call(int noteId, int tagId) async {
    await _db.tagsDao.removeTagFromNote(noteId, tagId);
  }
}
