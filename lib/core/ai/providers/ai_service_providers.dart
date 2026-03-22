import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/settings/domain/entities/ai_service_config.dart';
import '../../../features/settings/presentation/providers/active_config_providers.dart';
import '../ai_service_factory.dart';
import '../implementations/llm/null_llm_service.dart';
import '../implementations/stt/system_stt_service.dart';
import '../implementations/tts/system_tts_service.dart';
import '../interfaces/i_llm_service.dart';
import '../interfaces/i_stt_service.dart';
import '../interfaces/i_tts_service.dart';

export '../implementations/llm/null_llm_service.dart' show NullLLMService;

/// LLM service Notifier: holds the last-known-good ILLMService instance.
/// Listens to the active LLM config; only updates the service when config
/// is fully resolved (valueOrNull != null). When config is briefly in
/// AsyncLoading(hasValue: false) due to ref.invalidate, the previous service
/// is preserved — preventing the intermittent "please configure LLM" error.
class _LlmServiceNotifier extends Notifier<ILLMService> {
  @override
  ILLMService build() {
    ref.listen(activeConfigWithKeyProvider(AIServiceType.llm), (_, next) {
      final result = next.valueOrNull;
      if (result != null) {
        state = AIServiceFactory().createLlmService(result);
      }
    });
    final initial = ref.read(activeConfigWithKeyProvider(AIServiceType.llm));
    final result = initial.valueOrNull;
    return result != null
        ? AIServiceFactory().createLlmService(result)
        : const NullLLMService();
  }
}

final llmServiceProvider =
    NotifierProvider<_LlmServiceNotifier, ILLMService>(_LlmServiceNotifier.new);

/// TTS service Notifier: holds the last-known-good ITTSService instance.
/// See [_LlmServiceNotifier] for the rationale.
class _TtsServiceNotifier extends Notifier<ITTSService> {
  @override
  ITTSService build() {
    ref.listen(activeConfigWithKeyProvider(AIServiceType.tts), (_, next) {
      final result = next.valueOrNull;
      if (result != null) {
        state = AIServiceFactory().createTtsService(result);
      }
    });
    final initial = ref.read(activeConfigWithKeyProvider(AIServiceType.tts));
    final result = initial.valueOrNull;
    return result != null
        ? AIServiceFactory().createTtsService(result)
        : SystemTtsService();
  }
}

final ttsServiceProvider =
    NotifierProvider<_TtsServiceNotifier, ITTSService>(_TtsServiceNotifier.new);

/// STT service Notifier: holds the last-known-good ISTTService instance.
/// See [_LlmServiceNotifier] for the rationale.
class _SttServiceNotifier extends Notifier<ISTTService> {
  @override
  ISTTService build() {
    ref.listen(activeConfigWithKeyProvider(AIServiceType.stt), (_, next) {
      final result = next.valueOrNull;
      if (result != null) {
        state = AIServiceFactory().createSttService(result);
      }
    });
    final initial = ref.read(activeConfigWithKeyProvider(AIServiceType.stt));
    final result = initial.valueOrNull;
    return result != null
        ? AIServiceFactory().createSttService(result)
        : SystemSttService();
  }
}

final sttServiceProvider =
    NotifierProvider<_SttServiceNotifier, ISTTService>(_SttServiceNotifier.new);
