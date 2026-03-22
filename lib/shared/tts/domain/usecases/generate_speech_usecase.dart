import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ai/interfaces/i_tts_service.dart';
import '../../../../core/ai/providers/ai_service_providers.dart';
import '../../../../core/utils/logger.dart';
import '../entities/tts_audio.dart';

class GenerateSpeechUseCase {
  const GenerateSpeechUseCase(this._ttsService);

  final ITTSService _ttsService;

  /// Generates speech and returns a TtsAudio (with file path and size in bytes).
  /// If the TTS service returns an empty path (system TTS reads aloud directly), returns an empty TtsAudio.
  /// If the TTS service throws an exception, logs the error and returns an empty TtsAudio (graceful degradation).
  Future<TtsAudio> execute(String text, {String? voice}) async {
    try {
      final filePath = await _ttsService.generate(text, voice: voice);
      if (filePath.isEmpty) {
        return const TtsAudio(filePath: '', sizeBytes: 0);
      }

      final file = File(filePath);
      final exists = await file.exists();
      final sizeBytes = exists ? await file.length() : 0;
      return TtsAudio(filePath: filePath, sizeBytes: sizeBytes);
    } on Exception catch (e, stack) {
      appLogger.e('GenerateSpeechUseCase: TTS 服务异常，降级返回空音频', error: e, stackTrace: stack);
      return const TtsAudio(filePath: '', sizeBytes: 0);
    }
  }
}

final generateSpeechUseCaseProvider = Provider<GenerateSpeechUseCase>((ref) {
  return GenerateSpeechUseCase(ref.watch(ttsServiceProvider));
});
