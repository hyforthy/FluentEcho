// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_service_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIServiceConfigImpl _$$AIServiceConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$AIServiceConfigImpl(
      id: json['id'] as String,
      serviceType: $enumDecode(_$AIServiceTypeEnumMap, json['serviceType']),
      providerKey: json['providerKey'] as String,
      displayName: json['displayName'] as String,
      model: json['model'] as String,
      customBaseUrl: json['customBaseUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AIServiceConfigImplToJson(
        _$AIServiceConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceType': _$AIServiceTypeEnumMap[instance.serviceType]!,
      'providerKey': instance.providerKey,
      'displayName': instance.displayName,
      'model': instance.model,
      'customBaseUrl': instance.customBaseUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AIServiceTypeEnumMap = {
  AIServiceType.llm: 'llm',
  AIServiceType.tts: 'tts',
  AIServiceType.stt: 'stt',
};
