import 'dart:async';
import 'save_note_usecase.dart';
import 'auto_tag_note_usecase.dart';

class SaveAndTagNoteUseCase {
  final SaveNoteUseCase _saveNote;
  final AutoTagNoteUseCase _autoTag;

  SaveAndTagNoteUseCase({
    required SaveNoteUseCase saveNote,
    required AutoTagNoteUseCase autoTag,
  })  : _saveNote = saveNote,
        _autoTag = autoTag;

  Future<int> call({
    required String originalText,
    String? optimizedText,
    String? translatedText,
    required String detectedLanguage,
    required double confidence,
  }) async {
    final noteId = await _saveNote.call(
      originalText: originalText,
      optimizedText: optimizedText,
      translatedText: translatedText,
      detectedLanguage: detectedLanguage,
      confidence: confidence,
    );
    // Fire-and-forget: auto-tag does not block save confirmation
    unawaited(_autoTag.call(
      noteId: noteId,
      originalText: originalText,
      optimizedText: optimizedText,
      translatedText: translatedText,
    ));
    return noteId;
  }
}
