import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/entities/settings_entity.dart';
import '../../../core/storage/secure_storage_service.dart';

class SettingsRepositoryImpl {
  final FlutterSecureStorage _secureStorage;

  SettingsRepositoryImpl(this._secureStorage);

  Future<SettingsEntity> load() async {
    final speedStr = await _secureStorage.read(
      key: 'settings_tts_playback_speed',
    );
    final setupStr = await _secureStorage.read(
      key: 'settings_has_completed_setup',
    );
    final autoDeleteStr = await _secureStorage.read(
      key: 'settings_auto_delete_temp_audio',
    );

    return SettingsEntity(
      ttsPlaybackSpeed: speedStr != null ? double.tryParse(speedStr) ?? 1.0 : 1.0,
      hasCompletedSetup: setupStr == 'true',
      autoDeleteTempAudioOnClear: autoDeleteStr != 'false',
    );
  }

  Future<void> save(SettingsEntity settings) async {
    await _secureStorage.write(
      key: 'settings_tts_playback_speed',
      value: settings.ttsPlaybackSpeed.toString(),
    );
    await _secureStorage.write(
      key: 'settings_has_completed_setup',
      value: settings.hasCompletedSetup.toString(),
    );
    await _secureStorage.write(
      key: 'settings_auto_delete_temp_audio',
      value: settings.autoDeleteTempAudioOnClear.toString(),
    );
  }
}

final settingsRepositoryProvider = Provider<SettingsRepositoryImpl>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return SettingsRepositoryImpl(storage);
});
