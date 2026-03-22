// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsEntityImpl _$$SettingsEntityImplFromJson(Map<String, dynamic> json) =>
    _$SettingsEntityImpl(
      ttsPlaybackSpeed: (json['ttsPlaybackSpeed'] as num?)?.toDouble() ?? 1.0,
      hasCompletedSetup: json['hasCompletedSetup'] as bool? ?? false,
      autoDeleteTempAudioOnClear:
          json['autoDeleteTempAudioOnClear'] as bool? ?? true,
    );

Map<String, dynamic> _$$SettingsEntityImplToJson(
        _$SettingsEntityImpl instance) =>
    <String, dynamic>{
      'ttsPlaybackSpeed': instance.ttsPlaybackSpeed,
      'hasCompletedSetup': instance.hasCompletedSetup,
      'autoDeleteTempAudioOnClear': instance.autoDeleteTempAudioOnClear,
    };
