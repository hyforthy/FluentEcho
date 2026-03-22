enum TTSProvider { openai, openaiCompatible, system, volcano }

/// TTS service interface.
/// Architectural constraint: the [text] parameter must be English text (optimizedText);
///                           passing translatedText or raw Chinese input is forbidden.
/// The offline fallback (flutter_tts) implementation must call setLanguage('en-US') to lock
/// the language to English, preventing devices with a Chinese system language from reading
/// English text using a Chinese speech engine.
abstract class ITTSService {
  TTSProvider get provider;

  /// Generates TTS audio and returns the local file path (timeout: 30s).
  /// [text]  — English text (optimizedText only); passing translatedText or Chinese source is forbidden.
  /// [voice] — Speaker identifier (provider-specific; null means use the provider's default).
  Future<String> generate(String text, {String? voice});

  /// Streaming generation (optional support; throw UnsupportedError if not supported)
  Stream<List<int>> generateStream(String text, {String? voice});

  /// Checks service availability (whether the API key is configured and the network is reachable)
  Future<bool> isAvailable();
}
