import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/settings_repository_impl.dart';
import '../domain/entities/settings_entity.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<SettingsEntity> build() async {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.load();
  }

  Future<void> updatePlaybackSpeed(double speed) async {
    final repo = ref.read(settingsRepositoryProvider);
    final current = await repo.load();
    await repo.save(current.copyWith(ttsPlaybackSpeed: speed));
    ref.invalidateSelf();
  }
}
