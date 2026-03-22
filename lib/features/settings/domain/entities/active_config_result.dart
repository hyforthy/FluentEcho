import 'package:freezed_annotation/freezed_annotation.dart';
import 'ai_service_config.dart';

part 'active_config_result.freezed.dart';

@freezed
class ActiveConfigResult with _$ActiveConfigResult {
  const factory ActiveConfigResult.configured({
    required AIServiceConfig config,
    required String apiKey,
  }) = ConfiguredResult;

  const factory ActiveConfigResult.noActiveConfig() = NoActiveConfigResult;

  const factory ActiveConfigResult.missingKey({
    required AIServiceConfig config,
  }) = MissingKeyResult;
}
