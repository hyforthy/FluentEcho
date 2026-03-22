import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ai/interfaces/i_llm_service.dart';
import '../../../../core/ai/providers/ai_service_providers.dart';
import '../entities/optimization_result.dart';
import '../services/language_detector.dart';

class OptimizeTextUseCase {
  const OptimizeTextUseCase(this._llmService, this._detector);

  final ILLMService _llmService;
  final LanguageDetector _detector;

  /// Returns a Stream<OptimizationResult> where each yield carries the accumulated optimizedText so far.
  Stream<OptimizationResult> execute(String inputText) async* {
    final detected = _detector.detect(inputText);
    final buffer = StringBuffer();

    await for (final delta in _llmService.optimizeTextStream(
      text: inputText,
      detectedLanguage: detected,
    )) {
      buffer.write(delta);
      yield OptimizationResult(
        optimizedText: buffer.toString(),
        detectedLanguage: detected,
      );
    }
  }
}

final optimizeTextUseCaseProvider = Provider<OptimizeTextUseCase>((ref) {
  return OptimizeTextUseCase(
    ref.watch(llmServiceProvider),
    LanguageDetector(),
  );
});
