import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ai/interfaces/i_llm_service.dart';
import '../../../../core/ai/providers/ai_service_providers.dart';
import '../entities/detected_language.dart';

class TranslateTextUseCase {
  const TranslateTextUseCase(this._llmService);

  final ILLMService _llmService;

  /// Translates English text to Chinese and returns the translated string.
  Future<String> execute(String englishText) async {
    return _llmService.translate(
      text: englishText,
      detectedLanguage: const DetectedLanguage(
        language: 'en',
        confidence: 1.0,
        source: DetectionSource.rule,
      ),
    );
  }
}

final translateTextUseCaseProvider = Provider<TranslateTextUseCase>((ref) {
  return TranslateTextUseCase(ref.watch(llmServiceProvider));
});
