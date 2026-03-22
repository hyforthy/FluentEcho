import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entity.freezed.dart';
part 'settings_entity.g.dart';

@freezed
class SettingsEntity with _$SettingsEntity {
  const factory SettingsEntity({
    @Default(1.0) double ttsPlaybackSpeed,
    @Default(false) bool hasCompletedSetup,
    @Default(true) bool autoDeleteTempAudioOnClear,
  }) = _SettingsEntity;

  factory SettingsEntity.fromJson(Map<String, dynamic> json) =>
      _$SettingsEntityFromJson(json);
}
