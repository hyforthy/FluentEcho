import 'package:freezed_annotation/freezed_annotation.dart';
import 'detected_language.dart';

part 'optimization_result.freezed.dart';

@freezed
class OptimizationResult with _$OptimizationResult {
  const factory OptimizationResult({
    required String optimizedText,
    String? translatedText,
    required DetectedLanguage detectedLanguage,
    @Default(false) bool parseWarning,
  }) = _OptimizationResult;
}
