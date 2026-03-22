import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_service_config.freezed.dart';
part 'ai_service_config.g.dart';

enum AIServiceType { llm, tts, stt }

@freezed
class AIServiceConfig with _$AIServiceConfig {
  const factory AIServiceConfig({
    required String id,
    required AIServiceType serviceType,
    required String providerKey,
    required String displayName,
    required String model,
    String? customBaseUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AIServiceConfig;

  factory AIServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$AIServiceConfigFromJson(json);
}
