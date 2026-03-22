import '../../../../core/errors/app_exception.dart';
import '../../interfaces/i_tts_service.dart';

/// Fallback TTS used when no TTS service is configured.
/// All methods throw [MissingKeyException] to prompt the user to configure a TTS service.
class SystemTtsService implements ITTSService {
  @override
  TTSProvider get provider => TTSProvider.system;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<String> generate(String text, {String? voice}) {
    throw const MissingKeyException('TTS service is not configured');
  }

  @override
  Stream<List<int>> generateStream(String text, {String? voice}) {
    throw const MissingKeyException('TTS service is not configured');
  }
}
