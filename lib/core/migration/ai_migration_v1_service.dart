import 'package:drift/drift.dart' hide JsonKey;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../utils/logger.dart';
import '../database/app_database.dart';
import '../../features/settings/domain/entities/ai_service_config.dart';

part 'ai_migration_v1_service.freezed.dart';

class AIMigrationV1Service {
  final FlutterSecureStorage _secureStorage;
  final AppDatabase _db;

  static const String _migrationDoneKey = 'migration_ai_multiconfig_v1_done';

  AIMigrationV1Service({
    required FlutterSecureStorage secureStorage,
    required AppDatabase db,
  })  : _secureStorage = secureStorage,
        _db = db;

  Future<MigrationResult> runIfNeeded() async {
    final done = await _secureStorage.read(key: _migrationDoneKey);
    if (done == 'true') {
      return const MigrationResult.skipped();
    }

    try {
      await _migrate();
      await _secureStorage.write(key: _migrationDoneKey, value: 'true');
      return const MigrationResult.success();
    } catch (e, st) {
      appLogger.e(
        '[Migration] AIMigrationV1Service failed',
        error: e,
        stackTrace: st,
      );
      return MigrationResult.failed(error: e);
    }
  }

  Future<void> _migrate() async {
    final oldLlmProvider = await _tryReadKeys(['settings_llm_provider']);
    final oldLlmApiKey = await _tryReadKeys(['settings_llm_api_key']);
    final oldLlmModel = await _tryReadKeys(['settings_llm_model']);
    final oldLlmBaseUrl = await _tryReadKeys(['settings_llm_custom_base_url']);

    final oldTtsProvider = await _tryReadKeys(['settings_tts_provider']);
    final oldTtsApiKey = await _tryReadKeys(['settings_tts_api_key']);
    final oldTtsVoice = await _tryReadKeys(['settings_tts_voice']);
    final oldTtsBaseUrl = await _tryReadKeys(['settings_tts_custom_base_url']);

    final oldSttProvider = await _tryReadKeys(['settings_stt_provider']);
    final oldSttApiKey = await _tryReadKeys(['settings_stt_api_key']);
    final oldSttBaseUrl = await _tryReadKeys(['settings_stt_custom_base_url']);

    String? migratedLlmId;
    String? migratedTtsId;
    String? migratedSttId;

    if (oldLlmProvider != null) {
      migratedLlmId = await _createMigratedConfig(
        serviceType: AIServiceType.llm,
        providerKey: oldLlmProvider,
        displayName: '已迁移的 LLM 配置',
        model: oldLlmModel ?? '',
        apiKey: oldLlmApiKey,
        customBaseUrl: oldLlmBaseUrl,
      );
    }

    if (oldTtsProvider != null) {
      migratedTtsId = await _createMigratedConfig(
        serviceType: AIServiceType.tts,
        providerKey: oldTtsProvider,
        displayName: '已迁移的 TTS 配置',
        model: oldTtsVoice ?? '',
        apiKey: oldTtsApiKey,
        customBaseUrl: oldTtsBaseUrl,
      );
    }

    if (oldSttProvider != null) {
      migratedSttId = await _createMigratedConfig(
        serviceType: AIServiceType.stt,
        providerKey: oldSttProvider,
        displayName: '已迁移的 STT 配置',
        model: '',
        apiKey: oldSttApiKey,
        customBaseUrl: oldSttBaseUrl,
      );
    }

    if (migratedLlmId != null) {
      await _secureStorage.write(
        key: 'settings_active_llm_config_id',
        value: migratedLlmId,
      );
    }
    if (migratedTtsId != null) {
      await _secureStorage.write(
        key: 'settings_active_tts_config_id',
        value: migratedTtsId,
      );
    }
    if (migratedSttId != null) {
      await _secureStorage.write(
        key: 'settings_active_stt_config_id',
        value: migratedSttId,
      );
    }

    await _deleteOldKeys();
  }

  Future<String?> _tryReadKeys(List<String> candidates) async {
    for (final key in candidates) {
      final value = await _secureStorage.read(key: key);
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  Future<String> _createMigratedConfig({
    required AIServiceType serviceType,
    required String providerKey,
    required String displayName,
    required String model,
    String? apiKey,
    String? customBaseUrl,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();

    await _db.aiServiceConfigsDao.insert(
      AiServiceConfigsCompanion.insert(
        id: id,
        serviceType: serviceType.name,
        providerKey: providerKey,
        displayName: displayName,
        model: model,
        customBaseUrl: Value(customBaseUrl),
        createdAt: now,
        updatedAt: now,
      ),
    );

    if (apiKey != null && apiKey.isNotEmpty) {
      await _secureStorage.write(key: 'config_key_$id', value: apiKey);
    }

    return id;
  }

  Future<void> _deleteOldKeys() async {
    final oldKeys = [
      'settings_llm_provider',
      'settings_llm_api_key',
      'settings_llm_model',
      'settings_llm_custom_base_url',
      'settings_tts_provider',
      'settings_tts_api_key',
      'settings_tts_voice',
      'settings_tts_custom_base_url',
      'settings_stt_provider',
      'settings_stt_api_key',
      'settings_stt_custom_base_url',
    ];
    for (final key in oldKeys) {
      try {
        await _secureStorage.delete(key: key);
      } catch (_) {
        // Deletion failure does not affect migration outcome
      }
    }
  }
}

@freezed
class MigrationResult with _$MigrationResult {
  const factory MigrationResult.skipped() = _Skipped;
  const factory MigrationResult.success() = _Success;
  const factory MigrationResult.failed({required Object error}) = _Failed;
}
