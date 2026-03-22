import 'package:freezed_annotation/freezed_annotation.dart';
import 'detected_language.dart';

part 'conversation_entry.freezed.dart';

@freezed
class ConversationEntry with _$ConversationEntry {
  const factory ConversationEntry({
    required String id,
    required String originalText,
    required String optimizedText,
    String? translatedText,
    required DetectedLanguage detectedLanguage,
    String? audioFilePath,
    required DateTime createdAt,
    @Default(false) bool isFromVoice,
    @Default(false) bool parseWarning,
    String? errorMessage,
    int? savedNoteId,
  }) = _ConversationEntry;
}

extension ConversationEntryX on ConversationEntry {
  bool get isSaved => savedNoteId != null;

  /// Freezed's copyWith silently ignores null for nullable fields.
  /// Use this method to explicitly clear savedNoteId.
  ConversationEntry clearSavedNoteId() => ConversationEntry(
        id: id,
        originalText: originalText,
        optimizedText: optimizedText,
        translatedText: translatedText,
        detectedLanguage: detectedLanguage,
        audioFilePath: audioFilePath,
        createdAt: createdAt,
        isFromVoice: isFromVoice,
        parseWarning: parseWarning,
        errorMessage: errorMessage,
        savedNoteId: null,
      );
}
