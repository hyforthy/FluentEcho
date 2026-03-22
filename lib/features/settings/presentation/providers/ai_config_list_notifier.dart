import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/ai_config_repository_impl.dart';
import '../../domain/entities/ai_service_config.dart';
import 'active_config_providers.dart';

part 'ai_config_list_notifier.g.dart';

/// AI config list Notifier (family by AIServiceType).
/// Write operations call ref.invalidateSelf() to keep UI in sync with DB state.
@Riverpod(keepAlive: true)
class AiConfigListNotifier extends _$AiConfigListNotifier {
  late AIServiceType _serviceType;

  @override
  Future<List<AIServiceConfig>> build(AIServiceType type) async {
    _serviceType = type;
    final repo = ref.watch(aiConfigRepositoryProvider);
    return repo.getConfigs(type);
  }

  Future<void> add(AIServiceConfig config, {required String apiKey}) async {
    final repo = ref.read(aiConfigRepositoryProvider);
    final isFirst = (await repo.getConfigs(_serviceType)).isEmpty;
    await repo.addConfig(config, apiKey: apiKey);
    if (isFirst) {
      await repo.setActiveConfig(config.id, _serviceType);
    }
    ref.invalidateSelf();
    ref.invalidate(activeConfigIdProvider(_serviceType));
    ref.invalidate(activeConfigWithKeyProvider(_serviceType));
  }

  Future<void> updateConfig(AIServiceConfig config) async {
    final repo = ref.read(aiConfigRepositoryProvider);
    await repo.updateConfig(config);
    ref.invalidateSelf();
    ref.invalidate(activeConfigIdProvider(_serviceType));
    ref.invalidate(activeConfigWithKeyProvider(_serviceType));
  }

  /// Updates the API key for an existing config, then invalidates service providers.
  /// Key is written before invalidation so providers never rebuild against a stale key.
  Future<void> updateApiKey(String configId, String newApiKey) async {
    await ref.read(aiConfigRepositoryProvider).updateApiKey(configId, newApiKey);
    ref.invalidate(activeConfigWithKeyProvider(_serviceType));
  }

  Future<void> delete(String configId) async {
    final repo = ref.read(aiConfigRepositoryProvider);
    await repo.deleteConfig(configId, _serviceType);
    ref.invalidateSelf();
    // Sync active-config providers since deleted config may have been active
    ref.invalidate(activeConfigIdProvider(_serviceType));
    ref.invalidate(activeConfigWithKeyProvider(_serviceType));
  }

  Future<void> setActive(String configId) async {
    await ref.read(aiConfigRepositoryProvider).setActiveConfig(configId, _serviceType);
    // Only SecureStorage was written; list data is unchanged, so skip list reload.
    // Directly refresh the active-config providers.
    ref.invalidate(activeConfigIdProvider(_serviceType));
    ref.invalidate(activeConfigWithKeyProvider(_serviceType));
  }
}

// Alias for aiConfigListNotifierProvider to match the name used in ui-design-v3.md.
// The code-generated name is aiConfigListNotifierProvider; expose it via this alias.
// ignore: library_private_types_in_public_api
final aiConfigListProvider = aiConfigListNotifierProvider;
