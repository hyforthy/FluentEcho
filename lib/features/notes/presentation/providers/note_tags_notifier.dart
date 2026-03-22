import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ai/providers/ai_service_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/usecases/auto_tag_note_usecase.dart';
import '../../domain/usecases/manage_note_tags_usecase.dart';
import '../../domain/usecases/save_and_tag_note_usecase.dart';
import '../../domain/usecases/save_note_usecase.dart';

/// Current tag list for a specific note (Tag objects containing id and name)
final noteTagsProvider = StreamProvider.family<List<Tag>, int>((ref, noteId) {
  final db = ref.watch(appDatabaseProvider);
  return db.tagsDao.watchTagsForNote(noteId);
});

/// All existing tags — reactive stream so new tags appear immediately after auto-tagging.
final allTagsProvider = StreamProvider<List<Tag>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.tagsDao.watchAll();
});

/// AddTagToNoteUseCase provider
final addTagToNoteUseCaseProvider = Provider<AddTagToNoteUseCase>((ref) {
  return AddTagToNoteUseCase(ref.watch(appDatabaseProvider));
});

/// RemoveTagFromNoteUseCase provider
final removeTagFromNoteUseCaseProvider = Provider<RemoveTagFromNoteUseCase>((ref) {
  return RemoveTagFromNoteUseCase(ref.watch(appDatabaseProvider));
});

/// AutoTagNoteUseCase provider
final autoTagNoteUseCaseProvider = Provider<AutoTagNoteUseCase>((ref) {
  return AutoTagNoteUseCase(
    llm: ref.watch(llmServiceProvider),
    db: ref.watch(appDatabaseProvider),
  );
});

/// SaveAndTagNoteUseCase provider
final saveAndTagNoteUseCaseProvider = Provider<SaveAndTagNoteUseCase>((ref) {
  return SaveAndTagNoteUseCase(
    saveNote: ref.watch(saveNoteUseCaseProvider),
    autoTag: ref.watch(autoTagNoteUseCaseProvider),
  );
});
