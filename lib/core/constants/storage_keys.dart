class StorageKeys {
  static const String activeLlmConfigId = 'settings_active_llm_config_id';
  static const String activeTtsConfigId = 'settings_active_tts_config_id';
  static const String activeSttConfigId = 'settings_active_stt_config_id';
  static const String ttsPlaybackSpeed = 'settings_tts_playback_speed';
  static const String hasCompletedSetup = 'settings_has_completed_setup';
  static const String autoDeleteTempAudio = 'settings_auto_delete_temp_audio';
  static const String migrationAiMulticonfigV1Done = 'migration_ai_multiconfig_v1_done';

  static String apiKeyForConfig(String configId) => 'config_key_$configId';
  static String activeIdKey(String serviceTypeName) =>
      'settings_active_${serviceTypeName}_config_id';
}
