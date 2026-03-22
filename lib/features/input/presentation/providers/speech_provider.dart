import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../../core/ai/interfaces/i_stt_service.dart';
import '../../../../core/ai/providers/ai_service_providers.dart';

/// Audio recorder used by InputBar
/// Recording starts on long-press of the microphone button and stops on release, returning the audio file path
class AppAudioRecorder {
  final _recorder = AudioRecorder();
  String? _tempPath;

  Future<void> start() async {
    const config = RecordConfig(
      encoder: AudioEncoder.wav,
      sampleRate: 16000,
      numChannels: 1,
    );
    final dir = await getTemporaryDirectory();
    _tempPath = '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
    await _recorder.start(config, path: _tempPath!);
  }

  Future<String?> stop() async {
    return _recorder.stop();
  }

  Stream<double> amplitudeStream() {
    return Stream.periodic(const Duration(milliseconds: 80)).asyncMap((_) async {
      try {
        final amp = await _recorder.getAmplitude();
        return ((amp.current + 60) / 60).clamp(0.0, 1.0);
      } catch (_) {
        return 0.0;
      }
    });
  }

  Future<void> cancelAndDelete() async {
    final path = _tempPath;
    _tempPath = null;
    await _recorder.stop();
    if (path != null) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
  }
}

/// audioRecorderProvider — used by InputBar
final audioRecorderProvider = Provider<AppAudioRecorder>((ref) => AppAudioRecorder());

/// STT transcription use-case wrapper
class SttUseCase {
  final ISTTService _service;

  SttUseCase(this._service);

  Future<String> execute(String? audioPath) async {
    if (audioPath == null || audioPath.isEmpty) return '';
    final result = await _service.transcribe(audioPath);
    return result.text;
  }
}

/// sttUseCaseProvider — injects the STT service instance provided by sttServiceProvider
final sttUseCaseProvider = Provider<SttUseCase>((ref) {
  final sttService = ref.watch(sttServiceProvider);
  return SttUseCase(sttService);
});
