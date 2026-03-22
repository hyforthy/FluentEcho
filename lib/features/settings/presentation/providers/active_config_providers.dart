import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/ai_config_repository_impl.dart';
import '../../domain/entities/active_config_result.dart';
import '../../domain/entities/ai_service_config.dart';
import 'ai_config_list_notifier.dart';

/// Active config ID Provider (reads from SecureStorage).
/// Reads SecureStorage directly; does not depend on the config list.
/// Caller must explicitly invalidate this provider after setActive/delete.
final activeConfigIdProvider = FutureProvider.family<String?, AIServiceType>(
  (ref, type) async {
    final repo = ref.read(aiConfigRepositoryProvider);
    return repo.getActiveConfigId(type);
  },
);

/// Active config + API Key Provider.
/// Watches aiConfigListProvider(type): rebuilds when the list is invalidated (after setActive/add/delete).
/// Reads aiConfigRepositoryProvider directly to fetch the active ID and key from SecureStorage.
final activeConfigWithKeyProvider = FutureProvider.family<ActiveConfigResult, AIServiceType>(
  (ref, type) async {
    // Watch the config list so this provider rebuilds when the list is invalidated.
    await ref.watch(aiConfigListProvider(type).future);

    // Read the repository directly; avoids an extra watch dependency.
    final repo = ref.read(aiConfigRepositoryProvider);
    return repo.getActiveConfigWithKey(type);
  },
);
