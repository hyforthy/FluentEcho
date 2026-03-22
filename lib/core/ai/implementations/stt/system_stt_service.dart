import '../../interfaces/i_stt_service.dart';

/// System STT fallback service (speech_to_text plugin).
/// transcribe() is not applicable to the system STT (which is real-time streaming);
/// actual recording is handled by speech_provider.dart calling the SpeechToText plugin directly.
class SystemSttService implements ISTTService {
  @override
  STTProvider get provider => STTProvider.system;

  @override
  Future<bool> isAvailable() async {
    // Availability is checked by speech_provider.dart using SpeechToText.initialize();
    // conservatively return true here and let the caller handle unavailability at use time.
    return true;
  }

  @override
  Future<SttResult> transcribe(String audioPath) async {
    // System STT does not support file-based transcription; use the real-time streaming API instead.
    throw UnsupportedError(
      'SystemSttService does not support file-based transcription. '
      'Use speech_to_text plugin directly for real-time recognition.',
    );
  }
}
