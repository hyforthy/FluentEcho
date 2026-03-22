import '../entities/ai_service_config.dart';
import '../entities/active_config_result.dart';

abstract class IAIConfigRepository {
  Future<List<AIServiceConfig>> getConfigs(AIServiceType type);

  Future<String?> getActiveConfigId(AIServiceType type);

  Future<ActiveConfigResult> getActiveConfigWithKey(AIServiceType type);

  Future<void> addConfig(AIServiceConfig config, {required String apiKey});

  Future<void> updateConfig(AIServiceConfig config);

  Future<void> updateApiKey(String configId, String newApiKey);

  Future<void> deleteConfig(String configId, AIServiceType type);

  Future<void> setActiveConfig(String configId, AIServiceType type);
}
