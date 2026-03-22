import 'package:drift/drift.dart' hide JsonKey;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/entities/ai_service_config.dart';
import '../domain/entities/active_config_result.dart';
import '../domain/repositories/i_ai_config_repository.dart';
import '../../../core/database/app_database.dart';
import '../../../core/storage/secure_storage_service.dart';

class AIConfigRepositoryImpl implements IAIConfigRepository {
  final AppDatabase _db;
  final FlutterSecureStorage _secureStorage;

  AIConfigRepositoryImpl({
    required AppDatabase db,
    required FlutterSecureStorage secureStorage,
  })  : _db = db,
        _secureStorage = secureStorage;

  static String _activeIdKey(AIServiceType type) =>
      'settings_active_${type.name}_config_id';

  static String _apiKeyForConfig(String configId) => 'config_key_$configId';

  @override
  Future<List<AIServiceConfig>> getConfigs(AIServiceType type) async {
    final rows = await _db.aiServiceConfigsDao.getByType(type.name);
    return rows
        .map(_dataToEntityOrNull)
        .whereType<AIServiceConfig>()
        .toList();
  }

  @override
  Future<String?> getActiveConfigId(AIServiceType type) =>
      _secureStorage.read(key: _activeIdKey(type));

  @override
  Future<ActiveConfigResult> getActiveConfigWithKey(AIServiceType type) async {
    final activeId = await getActiveConfigId(type);
    if (activeId == null) return const ActiveConfigResult.noActiveConfig();

    final row = await _db.aiServiceConfigsDao.getById(activeId);
    if (row == null) {
      await _secureStorage.delete(key: _activeIdKey(type));
      return const ActiveConfigResult.noActiveConfig();
    }

    final config = _dataToEntity(row);
    final apiKey = await _secureStorage.read(key: _apiKeyForConfig(activeId));
    if (apiKey == null || apiKey.isEmpty) {
      return ActiveConfigResult.missingKey(config: config);
    }

    return ActiveConfigResult.configured(config: config, apiKey: apiKey);
  }

  @override
  Future<void> addConfig(AIServiceConfig config, {required String apiKey}) async {
    await _db.aiServiceConfigsDao.insert(_toCompanion(config));
    await _secureStorage.write(
      key: _apiKeyForConfig(config.id),
      value: apiKey,
    );
  }

  @override
  Future<void> updateConfig(AIServiceConfig config) async {
    await _db.aiServiceConfigsDao.updateConfig(_toCompanion(config));
  }

  @override
  Future<void> updateApiKey(String configId, String newApiKey) async {
    await _secureStorage.write(
      key: _apiKeyForConfig(configId),
      value: newApiKey,
    );
  }

  @override
  Future<void> deleteConfig(String configId, AIServiceType type) async {
    final activeId = await getActiveConfigId(type);
    final isActive = activeId == configId;

    await _db.aiServiceConfigsDao.deleteById(configId);
    await _secureStorage.delete(key: _apiKeyForConfig(configId));

    if (isActive) {
      await _secureStorage.delete(key: _activeIdKey(type));
    }
  }

  @override
  Future<void> setActiveConfig(String configId, AIServiceType type) async {
    final row = await _db.aiServiceConfigsDao.getById(configId);
    if (row == null) throw StateError('Config $configId not found');
    await _secureStorage.write(key: _activeIdKey(type), value: configId);
  }

  AIServiceConfig? _dataToEntityOrNull(AiServiceConfigData row) {
    final serviceType = AIServiceType.values
        .where((e) => e.name == row.serviceType)
        .firstOrNull;
    if (serviceType == null) return null;
    return AIServiceConfig(
      id: row.id,
      serviceType: serviceType,
      providerKey: row.providerKey,
      displayName: row.displayName,
      model: row.model,
      customBaseUrl: row.customBaseUrl,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  AIServiceConfig _dataToEntity(AiServiceConfigData row) {
    final entity = _dataToEntityOrNull(row);
    if (entity == null) {
      throw StateError('Unknown serviceType "${row.serviceType}" in config ${row.id}');
    }
    return entity;
  }

  AiServiceConfigsCompanion _toCompanion(AIServiceConfig config) =>
      AiServiceConfigsCompanion(
        id: Value(config.id),
        serviceType: Value(config.serviceType.name),
        providerKey: Value(config.providerKey),
        displayName: Value(config.displayName),
        model: Value(config.model),
        customBaseUrl: Value(config.customBaseUrl),
        createdAt: Value(config.createdAt),
        updatedAt: Value(config.updatedAt),
      );
}

final aiConfigRepositoryProvider = Provider<IAIConfigRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final storage = ref.watch(secureStorageProvider);
  return AIConfigRepositoryImpl(db: db, secureStorage: storage);
});
