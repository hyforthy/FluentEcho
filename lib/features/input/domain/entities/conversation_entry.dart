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
    @Default(false) bool skipOptimization,
    String? errorMessage,
    int? savedNoteId,
  }) = _ConversationEntry;
}

extension ConversationEntryX on ConversationEntry {
  bool get isSaved => savedNoteId != null;

  /// Returns a copy with originalText and optimizedText set to [text],
  /// translatedText explicitly cleared, and audioFilePath cleared.
  ConversationEntry withSkippedOptimization(String text) => ConversationEntry(
        id: id,
        originalText: text,
        optimizedText: text,
        translatedText: null,
        detectedLanguage: detectedLanguage,
        audioFilePath: null,
        createdAt: createdAt,
        isFromVoice: isFromVoice,
        parseWarning: parseWarning,
        skipOptimization: true,
        errorMessage: errorMessage,
        savedNoteId: savedNoteId,
      );

  /// Returns a copy with new originalText and cleared optimization results,
  /// ready for a full re-optimization pass.
  ConversationEntry withReoptimize(String newText) => ConversationEntry(
        id: id,
        originalText: newText,
        optimizedText: '',
        translatedText: null,
        detectedLanguage: detectedLanguage,
        audioFilePath: audioFilePath,
        createdAt: createdAt,
        isFromVoice: isFromVoice,
        parseWarning: false,
        skipOptimization: false,
        errorMessage: null,
        savedNoteId: savedNoteId,
      );

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
        skipOptimization: skipOptimization,
        errorMessage: errorMessage,
        savedNoteId: null,
      );
}
