import '../errors/app_exception.dart';
import '../../features/settings/domain/entities/active_config_result.dart';
import '../../features/settings/domain/entities/ai_service_config.dart';
import 'ai_provider_registry.dart';
import 'implementations/llm/claude_llm_service.dart';
import 'implementations/llm/openai_compatible_llm_service.dart';
import 'implementations/stt/system_stt_service.dart';
import 'implementations/stt/volcano_stt_service.dart';
import 'implementations/stt/whisper_compatible_stt_service.dart';
import 'implementations/tts/openai_tts_service.dart';
import 'implementations/tts/system_tts_service.dart';
import 'implementations/tts/volcano_tts_service.dart';
import 'implementations/llm/null_llm_service.dart';
import 'interfaces/i_llm_service.dart';
import 'interfaces/i_stt_service.dart';
import 'interfaces/i_tts_service.dart';

/// Creates the appropriate Service instance based on the ActiveConfigResult.
/// If no active config is set or the key is missing, returns a NullService
/// (any method call throws MissingKeyException) or a SystemService (TTS/STT fallback).
class AIServiceFactory {
  ILLMService createLlmService(ActiveConfigResult result) {
    return result.when(
      configured: (config, apiKey) => _buildLlmService(config, apiKey),
      noActiveConfig: () => const NullLLMService(),
      missingKey: (config) => const NullLLMService(),
    );
  }

  ITTSService createTtsService(ActiveConfigResult result) {
    return result.when(
      configured: (config, apiKey) => _buildTtsService(config, apiKey),
      noActiveConfig: () => SystemTtsService(),
      missingKey: (config) => SystemTtsService(),
    );
  }

  ISTTService createSttService(ActiveConfigResult result) {
    return result.when(
      configured: (config, apiKey) => _buildSttService(config, apiKey),
      noActiveConfig: () => SystemSttService(),
      missingKey: (config) => SystemSttService(),
    );
  }

  ILLMService _buildLlmService(AIServiceConfig config, String apiKey) {
    return switch (config.providerKey) {
      'claude' => ClaudeLLMService(
          apiKey: apiKey,
          model: _modelOrDefault(config),
          customBaseUrl: config.customBaseUrl,
        ),
      _ => OpenAICompatibleLLMService(
          apiKey: apiKey,
          model: _modelOrDefault(config),
          baseUrl: config.customBaseUrl ?? _defaultBaseUrl(config.providerKey),
        ),
    };
  }

  ITTSService _buildTtsService(AIServiceConfig config, String apiKey) {
    return switch (config.providerKey) {
      'volcano_tts' => _buildVolcanoTts(config, apiKey),
      'siliconflow_tts' => _buildSiliconflowTts(config, apiKey),
      'openai_tts' => OpenAITtsService(
          apiKey: apiKey,
          voice: _modelOrDefault(config),
        ),
      _ => SystemTtsService(),
    };
  }

  ISTTService _buildSttService(AIServiceConfig config, String apiKey) {
    return switch (config.providerKey) {
      'volcano_stt' => _buildVolcanoStt(config, apiKey),
      _ => WhisperCompatibleSttService(
          apiKey: apiKey,
          model: _modelOrDefault(config),
          baseUrl: config.customBaseUrl ?? _defaultBaseUrl(config.providerKey),
        ),
    };
  }

  // Volcano STT: apiKey stores "appId|accessKey", model stores resourceId (optional, defaults to volc.bigasr.auc_turbo)
  VolcanoSttService _buildVolcanoStt(AIServiceConfig config, String apiKey) {
    final parts = apiKey.split('|');
    final appId = parts.isNotEmpty ? parts[0] : '';
    final accessKey = parts.length > 1 ? parts[1] : '';
    final resourceId = _modelOrDefault(config);
    return VolcanoSttService(
      appId: appId,
      accessKey: accessKey,
      resourceId: resourceId.isNotEmpty ? resourceId : 'volc.bigasr.auc_turbo',
    );
  }

  // Volcano TTS: apiKey stores "appId|accessKey", model stores "resourceId:speakerId"
  VolcanoTtsService _buildVolcanoTts(AIServiceConfig config, String apiKey) {
    final parts = apiKey.split('|');
    final appId = parts.isNotEmpty ? parts[0] : '';
    final accessKey = parts.length > 1 ? parts[1] : '';
    final raw = _modelOrDefault(config);
    final colonIdx = raw.indexOf(':');
    if (colonIdx <= 0) {
      throw MissingKeyException(
          'Volcano TTS model field must be "resourceId:speakerId", got: $raw');
    }
    final resourceId = raw.substring(0, colonIdx);
    final speaker = raw.substring(colonIdx + 1);
    if (speaker.isEmpty) {
      throw MissingKeyException('Volcano TTS: speakerId is empty in model field');
    }
    return VolcanoTtsService(
      appId: appId,
      accessKey: accessKey,
      resourceId: resourceId,
      defaultSpeaker: speaker,
    );
  }

  // SiliconFlow TTS: config.model stores "ttsModel:voiceName"
  // e.g. "FunAudioLLM/CosyVoice2-0.5B:anna" or "fnlp/MOSS-TTSD-v0.5:alex"
  OpenAITtsService _buildSiliconflowTts(AIServiceConfig config, String apiKey) {
    final raw = _modelOrDefault(config); // e.g. "FunAudioLLM/CosyVoice2-0.5B:claire"
    final colonIdx = raw.lastIndexOf(':');
    final ttsModel = colonIdx > 0 ? raw.substring(0, colonIdx) : 'FunAudioLLM/CosyVoice2-0.5B';
    final voice    = colonIdx > 0 ? raw.substring(colonIdx + 1) : 'claire';
    return OpenAITtsService(
      apiKey: apiKey,
      model: ttsModel,
      voice: voice,
      baseUrl: config.customBaseUrl ?? _defaultBaseUrl(config.providerKey),
    );
  }

  /// Returns config.model if non-empty, otherwise falls back to the registry's
  /// defaultModel for the provider (allows users to leave the field blank).
  String _modelOrDefault(AIServiceConfig config) {
    final m = config.model.trim();
    if (m.isNotEmpty) return m;
    return AiProviderRegistry.defaultModel(config.providerKey) ?? '';
  }

  String _defaultBaseUrl(String providerKey) {
    return AiProviderRegistry.defaultBaseUrl(providerKey) ?? '';
  }
}
