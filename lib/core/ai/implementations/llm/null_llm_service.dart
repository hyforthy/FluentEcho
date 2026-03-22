import '../../../../core/errors/app_exception.dart';
import '../../../../features/input/domain/entities/detected_language.dart';
import '../../interfaces/i_llm_service.dart';

/// Placeholder LLM service used when no API key is configured.
/// Core methods throw MissingKeyException; suggestTags returns empty list.
class NullLLMService implements ILLMService {
  const NullLLMService();

  @override
  LLMProvider get provider => LLMProvider.openaiCompatible;

  @override
  bool get isConfigured => false;

  @override
  Stream<String> optimizeTextStream({
    required String text,
    required DetectedLanguage detectedLanguage,
  }) async* {
    throw const MissingKeyException(
        'No LLM service configured. Please add an API key in Settings.');
  }

  @override
  Future<String> translate({
    required String text,
    required DetectedLanguage detectedLanguage,
  }) {
    throw const MissingKeyException(
        'No LLM service configured. Please add an API key in Settings.');
  }

  @override
  Future<String> detectLanguage(String text) {
    throw const MissingKeyException(
        'No LLM service configured. Please add an API key in Settings.');
  }

  @override
  Future<List<String>> suggestTags({
    required String original,
    String? optimized,
    String? translated,
    int maxTags = 3,
  }) async => [];
}
