enum STTProvider {
  whisperCompatible,
  system,
  volcano,
}

/// STT transcription result
class SttResult {
  const SttResult({required this.text, required this.confidence});
  final String text;
  final double confidence;
}

abstract class ISTTService {
  STTProvider get provider;

  /// Transcribes an audio file to text.
  /// [audioPath] Local audio file path (AAC/PCM)
  Future<SttResult> transcribe(String audioPath);

  /// Checks service availability
  Future<bool> isAvailable();
}
