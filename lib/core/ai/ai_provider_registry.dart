import 'ai_provider_config.dart';

class AiProviderRegistry {
  static const List<AiProviderConfig> llmProviders = [
    AiProviderConfig(
      providerKey: 'deepseek',
      displayName: 'DeepSeek',
      defaultBaseUrl: 'https://api.deepseek.com/v1',
      defaultModel: 'deepseek-chat',
    ),
    AiProviderConfig(
      providerKey: 'moonshot',
      displayName: 'Moonshot Kimi',
      defaultBaseUrl: 'https://api.moonshot.cn/v1',
      defaultModel: 'moonshot-v1-8k',
    ),
    AiProviderConfig(
      providerKey: 'openai',
      displayName: 'OpenAI',
      defaultBaseUrl: 'https://api.openai.com/v1',
      defaultModel: 'gpt-4o',
    ),
    AiProviderConfig(
      providerKey: 'openrouter',
      displayName: 'OpenRouter',
      defaultBaseUrl: 'https://openrouter.ai/api/v1',
      defaultModel: 'openai/gpt-4o',
    ),
    AiProviderConfig(
      providerKey: 'minimax',
      displayName: 'MiniMax',
      defaultBaseUrl: 'https://api.minimax.chat/v1',
      defaultModel: 'MiniMax-Text-01',
    ),
    AiProviderConfig(
      providerKey: 'openai_compatible',
      displayName: '自定义（OpenAI 兼容）',
      defaultBaseUrl: null,
      defaultModel: null,
    ),
  ];

  static const List<AiProviderConfig> ttsProviders = [
    AiProviderConfig(
      providerKey: 'volcano_tts',
      displayName: '火山引擎 TTS（大模型）',
      defaultBaseUrl: null,
      defaultModel: 'seed-tts-2.0:zh_female_vv_uranus_bigtts',
      modelHint: '如：seed-tts-2.0:zh_female_vv_uranus_bigtts',
    ),
    AiProviderConfig(
      providerKey: 'siliconflow_tts',
      displayName: 'SiliconFlow TTS',
      defaultBaseUrl: 'https://api.siliconflow.cn/v1',
      // Format: "ttsModel:voiceName"
      // Available models: FunAudioLLM/CosyVoice2-0.5B, fnlp/MOSS-TTSD-v0.5
      // Available voices: alex, anna, bella, benjamin, charles, claire, david, diana
      defaultModel: 'FunAudioLLM/CosyVoice2-0.5B:claire',
      modelHint: '如：alex、anna、bella',
    ),
    AiProviderConfig(
      providerKey: 'openai_tts',
      displayName: 'OpenAI TTS',
      defaultBaseUrl: 'https://api.openai.com/v1',
      defaultModel: 'alloy',
    ),
  ];

  static const List<AiProviderConfig> sttProviders = [
    AiProviderConfig(
      providerKey: 'volcano_stt',
      displayName: '火山引擎 STT（大模型）',
      defaultBaseUrl: null,
      defaultModel: 'volc.bigasr.auc_turbo',
      modelHint: '如：volc.bigasr.auc_turbo',
    ),
    AiProviderConfig(
      providerKey: 'siliconflow',
      displayName: 'SiliconFlow SenseVoice',
      defaultBaseUrl: 'https://api.siliconflow.cn/v1',
      defaultModel: 'FunAudioLLM/SenseVoiceSmall',
      modelHint: '如：FunAudioLLM/SenseVoiceSmall、TeleAI/TeleSpeechASR',
    ),
    AiProviderConfig(
      providerKey: 'openai_whisper',
      displayName: 'OpenAI Whisper',
      defaultBaseUrl: 'https://api.openai.com/v1',
      defaultModel: 'whisper-1',
    ),
  ];

  static AiProviderConfig? _find(String providerKey) {
    for (final p in [...llmProviders, ...ttsProviders, ...sttProviders]) {
      if (p.providerKey == providerKey) return p;
    }
    return null;
  }

  static String? defaultBaseUrl(String providerKey) =>
      _find(providerKey)?.defaultBaseUrl;

  static String? defaultModel(String providerKey) =>
      _find(providerKey)?.defaultModel;

  /// UI placeholder for the model/voice field.
  /// Returns [modelHint] if set, otherwise falls back to [defaultModel].
  static String? modelHint(String providerKey) {
    final p = _find(providerKey);
    return p?.modelHint ?? p?.defaultModel;
  }
}
