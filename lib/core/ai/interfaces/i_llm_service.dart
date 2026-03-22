import '../../../features/input/domain/entities/detected_language.dart';

enum LLMProvider { claude, openaiCompatible }

abstract class ILLMService {
  LLMProvider get provider;

  /// Whether the service is configured (local check, no network request)
  bool get isConfigured;

  /// Streaming text optimization.
  /// - Chinese input: returns natural English (with grammar/spelling/vocabulary improvements)
  /// - English input: returns optimized English
  /// Returns Stream<String> where each event is an incremental text chunk.
  Stream<String> optimizeTextStream({
    required String text,
    required DetectedLanguage detectedLanguage,
  });

  /// Translates optimized English text into Chinese.
  Future<String> translate({
    required String text,
    required DetectedLanguage detectedLanguage,
  });

  /// Language detection fallback (called when character-set rules are inconclusive)
  Future<String> detectLanguage(String text);

  /// Classifies a note into 1-[maxTags] predefined categories (see kNoteCategories).
  /// Returns only values present in kNoteCategories. Never throws — returns [] on failure.
  Future<List<String>> suggestTags({
    required String original,
    String? optimized,
    String? translated,
    int maxTags = 3,
  });
}
